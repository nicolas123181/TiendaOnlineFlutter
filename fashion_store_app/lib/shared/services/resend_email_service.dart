// Servicio para enviar emails directamente via Resend API.
// Usado como fallback cuando la API web de Astro no está disponible o devuelve 401.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/app_constants.dart';

class ResendEmailService {
  static const String _baseUrl = 'https://api.resend.com/emails';
  static const String _from = 'Vantage <onboarding@resend.dev>';
  static const String _siteUrl = 'https://nicovantage.victoriafp.online';

  static String get _apiKey {
    try {
      return AppConstants.resendApiKey;
    } catch (_) {
      return '';
    }
  }

  static final HtmlEscape _htmlEscape = const HtmlEscape();

  static String _normalizeText(String value) {
    if (value.isEmpty) return value;

    final hasMojibakeMarkers =
        value.contains('Ã') ||
        value.contains('Â') ||
        value.contains('â€') ||
        value.contains('�');

    if (!hasMojibakeMarkers) return value;

    try {
      return utf8.decode(latin1.encode(value));
    } catch (_) {
      return value;
    }
  }

  static String _safeHtmlText(String value) {
    return _htmlEscape.convert(_normalizeText(value));
  }

  /// Adjunto para emails (PDF, etc.)
  static Map<String, dynamic> makeAttachment({
    required String filename,
    required List<int> content,
  }) {
    return {'filename': filename, 'content': base64Encode(content)};
  }

  /// Envía un email genérico. Retorna true si tuvo éxito.
  static Future<bool> _sendEmail({
    required String to,
    required String subject,
    required String html,
    List<Map<String, dynamic>>? attachments,
  }) async {
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      debugPrint(
        '[ResendEmail] RESEND_API_KEY vacía, no se puede enviar email',
      );
      return false;
    }

    try {
      final body = <String, dynamic>{
        'from': _from,
        'to': [to],
        'subject': subject,
        'html': html,
      };

      if (attachments != null && attachments.isNotEmpty) {
        body['attachments'] = attachments;
      }

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint(
        '[ResendEmail] Respuesta: ${response.statusCode} - ${response.body}',
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ResendEmail] Error enviando email: $e');
      return false;
    }
  }

  // ============================================
  // EMAILS DE PEDIDOS
  // ============================================

  /// Email: Pedido listo para recoger en tienda
  static Future<bool> sendReadyForPickupEmail({
    required int orderId,
    required String customerEmail,
    required String customerName,
  }) {
    final orderNum = orderId.toString().padLeft(5, '0');
    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject: '¡Tu pedido #$orderNum está listo para recoger!',
      html: _readyForPickupHtml(orderNum, _safeHtmlText(customerName)),
    );
  }

  /// Email: Pedido enviado con tracking
  static Future<bool> sendShippedEmail({
    required int orderId,
    required String customerEmail,
    required String customerName,
    String? carrierName,
    String? trackingNumber,
    String? trackingUrl,
  }) {
    final orderNum = orderId.toString().padLeft(5, '0');
    final safeCustomerName = _safeHtmlText(customerName);
    final safeCarrier = _safeHtmlText(carrierName ?? '');
    final safeTrackingNumber = _safeHtmlText(trackingNumber ?? '');
    final safeTrackingUrl = _safeHtmlText(trackingUrl ?? '');

    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject: '🚚 Tu pedido #$orderNum va en camino',
      html: _shippedHtml(
        orderNum,
        safeCustomerName,
        safeCarrier,
        safeTrackingNumber,
        safeTrackingUrl,
      ),
    );
  }

  /// Email: Pedido entregado
  static Future<bool> sendDeliveredEmail({
    required int orderId,
    required String customerEmail,
    required String customerName,
  }) {
    final orderNum = orderId.toString().padLeft(5, '0');
    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject: '✅ Tu pedido #$orderNum ha sido entregado',
      html: _deliveredHtml(orderNum, _safeHtmlText(customerName)),
    );
  }

  // ============================================
  // EMAILS DE DEVOLUCIONES
  // ============================================

  /// Email: Devolución recibida, en revisión
  static Future<bool> sendReturnReceivedEmail({
    required String customerEmail,
    required String customerName,
    required String returnNumber,
  }) {
    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject: '📦 Hemos recibido tu devolución - $returnNumber',
      html: _returnReceivedHtml(
        _safeHtmlText(customerName),
        _safeHtmlText(returnNumber),
      ),
    );
  }

  /// Email: Reembolso procesado (con factura rectificativa adjunta opcional)
  static Future<bool> sendRefundProcessedEmail({
    required String customerEmail,
    required String customerName,
    required String returnNumber,
    required double amount,
    List<Map<String, dynamic>>? attachments,
  }) {
    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject: 'Reembolso procesado - ${_normalizeText(returnNumber)}',
      html: _refundProcessedHtml(
        _safeHtmlText(customerName),
        _safeHtmlText(returnNumber),
        amount,
      ),
      attachments: attachments,
    );
  }

  /// Email: Devolución rechazada
  static Future<bool> sendReturnRejectedEmail({
    required String customerEmail,
    required String customerName,
    required String returnNumber,
    required String reason,
  }) {
    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject:
          'Actualización sobre tu devolución - ${_normalizeText(returnNumber)}',
      html: _returnRejectedHtml(
        _safeHtmlText(customerName),
        _safeHtmlText(returnNumber),
        _safeHtmlText(reason),
      ),
    );
  }

  /// Email: Pedido cancelado por admin (con factura rectificativa adjunta opcional)
  static Future<bool> sendOrderCancelledEmail({
    required int orderId,
    required String customerEmail,
    required String customerName,
    required double totalAmount,
    List<Map<String, dynamic>>? attachments,
  }) {
    final orderNum = orderId.toString().padLeft(5, '0');
    return _sendEmail(
      to: _normalizeText(customerEmail),
      subject: 'Pedido Cancelado - #$orderNum',
      html: _orderCancelledHtml(
        orderNum,
        _safeHtmlText(customerName),
        totalAmount,
      ),
      attachments: attachments,
    );
  }

  // ============================================
  // PLANTILLAS HTML
  // ============================================

  static const _navy = '#1a2744';
  static const _purple = '#7c3aed';
  static const _success = '#16a34a';
  static const _warning = '#d97706';

  static String _baseStyle() =>
      '''
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;line-height:1.6;color:#333;margin:0;padding:0;background:#f5f5f5}
    .c{max-width:600px;margin:0 auto;padding:40px 20px}
    .card{background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,.1)}
    .hdr{color:#fff;padding:40px;text-align:center}
    .logo{font-size:20px;font-weight:300;letter-spacing:.3em;margin-bottom:10px;opacity:.9}
    .hdr h1{margin:15px 0 0;font-size:24px;font-weight:400}
    .cnt{padding:40px}
    .onum{border-radius:12px;padding:20px;text-align:center;margin:20px 0}
    .onum span{font-size:28px;font-weight:bold}
    .btn{display:inline-block;background:$_navy;color:#fff;padding:16px 40px;text-decoration:none;border-radius:8px;font-weight:500;margin:20px 0}
    .ftr{text-align:center;padding:30px;background:#f9fafb;color:#6b7280;font-size:14px}
    .info{border-left:4px solid #f59e0b;padding:15px 20px;border-radius:0 8px 8px 0;margin:20px 0;background:#fef3c7}
  ''';

  static String _readyForPickupHtml(String orderNum, String name) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}</style></head>
<body><div class="c"><div class="card">
<div class="hdr" style="background:$_warning"><div class="logo">VANTAGE</div>
<p style="font-size:60px;margin:0">🎉</p><h1>¡Tu pedido está listo!</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>Tu pedido está <strong>listo para recoger</strong> en nuestra tienda.</p>
<div class="onum" style="background:#fef3c7"><p style="margin:0 0 5px;color:#6b7280">Número de pedido</p>
<span style="color:$_warning">#$orderNum</span></div>
<div class="info"><p style="margin:0"><strong>🏪 Recogida en Tienda</strong></p>
<p style="margin:10px 0 0;color:#6b7280">Pasa a recogerlo cuando desees. No olvides traer tu DNI o el número de pedido.</p></div>
<center><a href="$_siteUrl/perfil" class="btn">Ver Detalles del Pedido</a></center>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';

  static String _shippedHtml(
    String orderNum,
    String name,
    String carrier,
    String tracking,
    String trackingUrl,
  ) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}
.trk{background:linear-gradient(135deg,#f0fdf4,#ecfdf5);border:2px solid #86efac;border-radius:16px;padding:25px;margin:25px 0;text-align:center}
.trk .num{font-family:monospace;font-size:20px;font-weight:bold;color:$_success;background:#fff;padding:12px 20px;border-radius:8px;display:inline-block;margin:10px 0;letter-spacing:1px}
.trk-btn{display:inline-block;background:$_success;color:#fff;padding:16px 40px;text-decoration:none;border-radius:8px;font-weight:600;margin:15px 0;font-size:16px}
</style></head><body><div class="c"><div class="card">
<div class="hdr" style="background:linear-gradient(135deg,$_purple 0%,#2d4a6f 100%)"><div class="logo">VANTAGE</div>
<p style="font-size:60px;margin:0">🚚</p><h1>¡Tu pedido va en camino!</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>¡Buenas noticias! Tu pedido ha sido enviado y <strong>ya está en camino</strong>.</p>
<div class="onum" style="background:#f5f3ff"><p style="margin:0 0 5px;color:#6b7280">Pedido</p>
<span style="color:$_purple">#$orderNum</span></div>
${tracking.isNotEmpty ? '''
<div class="trk"><p style="font-size:18px;font-weight:600;color:$_navy;margin:0 0 10px">📦 Enviado con <strong>$carrier</strong></p>
<p style="margin:5px 0;color:#6b7280">Número de seguimiento:</p>
<div class="num">$tracking</div>
${trackingUrl.isNotEmpty ? '<br><a href="$trackingUrl" class="trk-btn" target="_blank">🔍 Rastrear mi Pedido</a>' : ''}
</div>''' : '''
<div class="trk" style="background:#f3f4f6;border:2px solid #e5e7eb">
<p style="font-size:18px;font-weight:600;color:$_navy;margin:0">📦 Tu pedido está en camino</p>
<p style="margin:10px 0;color:#6b7280">El transportista te contactará para la entrega.</p></div>'''}
<div class="info"><p style="margin:0"><strong>💡 Consejo:</strong> Guarda este número de seguimiento para consultar el estado en cualquier momento.</p></div>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';

  static String _deliveredHtml(String orderNum, String name) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}</style></head>
<body><div class="c"><div class="card">
<div class="hdr" style="background:$_success"><div class="logo">VANTAGE</div>
<p style="font-size:60px;margin:0">✅</p><h1>¡Pedido entregado!</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>Tu pedido <strong>#$orderNum</strong> ha sido <strong>entregado correctamente</strong>.</p>
<div class="onum" style="background:#f0fdf4"><p style="margin:0 0 5px;color:#6b7280">Pedido entregado</p>
<span style="color:$_success">#$orderNum</span></div>
<p>Esperamos que disfrutes tu compra. Si tienes alguna pregunta o necesitas devolver algún artículo, puedes hacerlo desde tu perfil.</p>
<center><a href="$_siteUrl/perfil" class="btn">Mi Perfil</a></center>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';

  static String _returnReceivedHtml(String name, String retNum) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}</style></head>
<body><div class="c"><div class="card">
<div class="hdr" style="background:$_purple"><div class="logo">VANTAGE</div>
<p style="font-size:48px;margin:0">📦</p><h1>¡Hemos recibido tu paquete!</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>Te confirmamos que hemos recibido tu devolución. Nuestro equipo está revisando los artículos.</p>
<div class="onum" style="background:#f5f3ff"><p style="margin:0 0 5px;color:#6b7280;font-size:14px">Número de devolución</p>
<span style="color:$_purple">$retNum</span>
<p style="margin:15px 0 0;font-size:14px;color:#6b7280">Estado: <strong style="color:$_purple">En revisión</strong></p></div>
<div class="info"><p style="margin:0"><strong>⏱ ¿Cuánto tarda?</strong></p>
<p style="margin:10px 0 0;color:#6b7280">La revisión tarda entre 2-4 días laborables. Te avisaremos del resultado.</p></div>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';

  static String _refundProcessedHtml(
    String name,
    String retNum,
    double amount,
  ) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}</style></head>
<body><div class="c"><div class="card">
<div class="hdr" style="background:$_success"><div class="logo">VANTAGE</div>
<p style="font-size:48px;margin:0">💰</p><h1>Reembolso procesado</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>Tu devolución <strong>$retNum</strong> ha sido aprobada y el reembolso procesado.</p>
<div class="onum" style="background:#f0fdf4">
<p style="margin:0 0 5px;color:#6b7280;font-size:14px">Importe reembolsado</p>
<span style="color:$_success">${amount.toStringAsFixed(2)} €</span></div>
<div class="info"><p style="margin:0"><strong>💳 ¿Cuándo recibiré el dinero?</strong></p>
<p style="margin:10px 0 0;color:#6b7280">El reembolso puede tardar entre 5-10 días hábiles en aparecer en tu cuenta.</p></div>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';

  static String _returnRejectedHtml(
    String name,
    String retNum,
    String reason,
  ) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}</style></head>
<body><div class="c"><div class="card">
<div class="hdr" style="background:$_navy"><div class="logo">VANTAGE</div>
<p style="font-size:48px;margin:0">📋</p><h1>Actualización de tu devolución</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>Hemos revisado tu devolución <strong>$retNum</strong> y lamentamos informarte de que no ha podido ser aceptada.</p>
<div style="background:#fef2f2;border:2px solid #fca5a5;border-radius:12px;padding:20px;margin:20px 0">
<p style="margin:0;font-weight:600;color:#dc2626">Motivo:</p>
<p style="margin:8px 0 0;color:#374151">$reason</p></div>
<p>Si tienes alguna pregunta, no dudes en contactarnos.</p>
<center><a href="$_siteUrl/perfil" class="btn">Mi Perfil</a></center>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';

  static String _orderCancelledHtml(
    String orderNum,
    String name,
    double totalAmount,
  ) =>
      '''
<!DOCTYPE html><html><head><meta charset="utf-8"><style>${_baseStyle()}</style></head>
<body><div class="c"><div class="card">
<div class="hdr" style="background:#dc2626"><div class="logo">VANTAGE</div>
<p style="font-size:60px;margin:0">❌</p><h1>Pedido Cancelado</h1></div>
<div class="cnt">
<p>Hola <strong>$name</strong>,</p>
<p>Tu pedido <strong>#$orderNum</strong> ha sido cancelado.</p>
<div class="onum" style="background:#fef2f2">
<p style="margin:0 0 5px;color:#6b7280;font-size:14px">Importe a reembolsar</p>
<span style="color:#dc2626">${totalAmount.toStringAsFixed(2)} €</span></div>
<div class="info"><p style="margin:0"><strong>💳 Reembolso</strong></p>
<p style="margin:10px 0 0;color:#6b7280">El reembolso puede tardar entre 5-10 días hábiles en aparecer en tu cuenta, dependiendo de tu banco.</p></div>
<p>Si has recibido una factura rectificativa, la encontrarás adjunta a este email.</p>
<center><a href="$_siteUrl/perfil" class="btn">Mi Perfil</a></center>
</div><div class="ftr"><p>© 2026 Vantage. Todos los derechos reservados.</p></div>
</div></div></body></html>''';
}
