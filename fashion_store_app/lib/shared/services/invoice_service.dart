// Servicio para crear facturas y facturas rectificativas (credit notes)
// directamente en Supabase desde Flutter.
//
// Replica la lógica de createInvoice() de FashionShop/src/lib/invoice.ts

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/constants/app_constants.dart';

/// Datos de la empresa (matching COMPANY_INFO en invoice.ts)
class CompanyInfo {
  static const name = 'Vantage Fashion S.L.';
  static const address = 'Calle de la Moda 123';
  static const city = '28001 Madrid, España';
  static const nif = 'B-12345678';
  static const email = 'facturas@vantage.com';
  static const phone = '+34 900 123 456';
}

/// Item para crear una factura
class CreditNoteItem {
  final int? productId;
  final String productName;
  final String? productSize;
  final int quantity;
  final int unitPrice; // en céntimos (negativo para credit notes)

  const CreditNoteItem({
    this.productId,
    required this.productName,
    this.productSize,
    required this.quantity,
    required this.unitPrice,
  });
}

class InvoiceService {
  final SupabaseClient _supabase;

  InvoiceService(this._supabase);

  /// Genera un número de factura único vía RPC o fallback
  Future<String> _generateInvoiceNumber() async {
    try {
      final result = await _supabase.rpc('generate_invoice_number');
      return result as String;
    } catch (_) {
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      return 'VNT-${DateTime.now().year}-${ts.substring(ts.length - 7)}';
    }
  }

  /// Busca la factura original (tipo standard) de un pedido
  Future<Map<String, dynamic>?> getOriginalInvoice(int orderId) async {
    try {
      final response = await _supabase
          .from('invoices')
          .select('*')
          .eq('order_id', orderId)
          .eq('type', 'standard')
          .order('created_at', ascending: true)
          .limit(1)
          .maybeSingle();

      return response;
    } catch (e) {
      // Si la columna 'type' no existe, intentar sin filtro
      try {
        final response = await _supabase
            .from('invoices')
            .select('*')
            .eq('order_id', orderId)
            .order('created_at', ascending: true)
            .limit(1)
            .maybeSingle();
        return response;
      } catch (e2) {
        debugPrint('[InvoiceService] Error buscando factura original: $e2');
        return null;
      }
    }
  }

  /// Garantiza que exista una factura estándar para el pedido.
  /// Si no existe, intenta crearla y devolverla.
  Future<Map<String, dynamic>?> ensureStandardInvoice(int orderId) async {
    final existing = await getOriginalInvoice(orderId);
    if (existing != null) return existing;

    try {
      final order = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', orderId)
          .single();

      final status = order['status'] as String? ?? '';
      if (status == 'pending') {
        return null;
      }

      final items = (order['order_items'] as List<dynamic>? ?? []);

      int subtotal = (order['subtotal'] as num?)?.toInt() ?? 0;
      if (subtotal <= 0 && items.isNotEmpty) {
        subtotal = items.fold<int>(0, (sum, item) {
          final m = item as Map<String, dynamic>;
          final unitPrice =
              (m['product_price'] as num?)?.toInt() ??
              (m['unit_price'] as num?)?.toInt() ??
              0;
          final qty = (m['quantity'] as num?)?.toInt() ?? 1;
          return sum + (unitPrice * qty);
        });
      }

      final discount = (order['discount'] as num?)?.toInt() ?? 0;
      final shippingCost = (order['shipping_cost'] as num?)?.toInt() ?? 0;
      const taxRate = 21.0;

      final subtotalAfterDiscount = subtotal - discount;
      final baseImponible = (subtotalAfterDiscount / (1 + taxRate / 100))
          .round();
      final taxAmount = subtotalAfterDiscount - baseImponible;
      final total = subtotalAfterDiscount + shippingCost;

      final invoiceRecord = <String, dynamic>{
        'invoice_number': await _generateInvoiceNumber(),
        'order_id': orderId,
        'customer_name': order['customer_name'] ?? 'Cliente',
        'customer_email': order['customer_email'] ?? '',
        'customer_address': order['customer_address'],
        'customer_city': order['customer_city'],
        'customer_postal_code': order['customer_postal_code'],
        'customer_phone': order['customer_phone'],
        'company_name': CompanyInfo.name,
        'company_address': '${CompanyInfo.address}, ${CompanyInfo.city}',
        'company_nif': CompanyInfo.nif,
        'company_email': CompanyInfo.email,
        'company_phone': CompanyInfo.phone,
        'subtotal': subtotal,
        'shipping_cost': shippingCost,
        'discount': discount,
        'tax_rate': taxRate,
        'tax_amount': taxAmount,
        'total': total,
        'payment_method': 'Tarjeta de crédito',
        'payment_status': status == 'cancelled' ? 'refunded' : 'paid',
        'status': 'issued',
        'type': 'standard',
      };

      Map<String, dynamic> invoice;
      try {
        invoice = await _supabase
            .from('invoices')
            .insert(invoiceRecord)
            .select()
            .single();
      } catch (e) {
        if (e.toString().contains('column') || e.toString().contains('42703')) {
          invoiceRecord.remove('type');
          invoiceRecord['invoice_number'] = await _generateInvoiceNumber();
          invoice = await _supabase
              .from('invoices')
              .insert(invoiceRecord)
              .select()
              .single();
        } else {
          rethrow;
        }
      }

      final invoiceId = (invoice['id'] as num).toInt();

      if (items.isNotEmpty) {
        final invoiceItems = items.map((item) {
          final m = item as Map<String, dynamic>;
          final unitPrice =
              (m['product_price'] as num?)?.toInt() ??
              (m['unit_price'] as num?)?.toInt() ??
              0;
          final qty = (m['quantity'] as num?)?.toInt() ?? 1;
          return <String, dynamic>{
            'invoice_id': invoiceId,
            'product_id': m['product_id'],
            'product_name': m['product_name'] ?? 'Producto',
            'product_size': m['size'] ?? m['product_size'],
            'quantity': qty,
            'unit_price': unitPrice,
            'line_total': unitPrice * qty,
          };
        }).toList();

        await _supabase.from('invoice_items').insert(invoiceItems);
      }

      return invoice;
    } catch (e) {
      debugPrint('[InvoiceService] Error asegurando factura estándar: $e');
      return null;
    }
  }

  /// Crea una factura rectificativa (credit note) para una devolución.
  ///
  /// Devuelve el mapa de la factura creada, o null si falla.
  Future<Map<String, dynamic>?> createCreditNote({
    required int orderId,
    required String customerName,
    required String customerEmail,
    required List<CreditNoteItem> items,
    required int refundAmountCents,
    String? notes,
    String? customerAddress,
    String? customerCity,
    String? customerPostalCode,
    String? customerPhone,
  }) async {
    try {
      // 1. Buscar factura original
      final originalInvoice = await ensureStandardInvoice(orderId);
      if (originalInvoice == null) {
        debugPrint(
          '[InvoiceService] No se encontró factura original para pedido #$orderId',
        );
        return null;
      }

      final originalId = (originalInvoice['id'] as num).toInt();
      final taxRate = (originalInvoice['tax_rate'] as num?)?.toDouble() ?? 21.0;

      // 2. Generar número de factura
      final invoiceNumber = await _generateInvoiceNumber();

      // 3. Calcular importes (negativos para credit note)
      final subtotal = -refundAmountCents.abs();
      final baseImponible = (subtotal / (1 + taxRate / 100)).round();
      final taxAmount = subtotal - baseImponible;
      // Credit notes no tienen envío
      final total = subtotal;

      // 4. Insertar factura rectificativa
      final invoiceRecord = <String, dynamic>{
        'invoice_number': invoiceNumber,
        'order_id': orderId,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'customer_address':
            customerAddress ?? originalInvoice['customer_address'],
        'customer_city': customerCity ?? originalInvoice['customer_city'],
        'customer_postal_code':
            customerPostalCode ?? originalInvoice['customer_postal_code'],
        'customer_phone': customerPhone ?? originalInvoice['customer_phone'],
        'company_name': CompanyInfo.name,
        'company_address': '${CompanyInfo.address}, ${CompanyInfo.city}',
        'company_nif': CompanyInfo.nif,
        'company_email': CompanyInfo.email,
        'company_phone': CompanyInfo.phone,
        'subtotal': subtotal,
        'shipping_cost': 0,
        'discount': 0,
        'tax_rate': taxRate,
        'tax_amount': taxAmount,
        'total': total,
        'payment_method': 'Reembolso',
        'payment_status': 'refunded',
        'status': 'issued',
        'notes': notes,
        'type': 'credit_note',
        'original_invoice_id': originalId,
      };

      Map<String, dynamic> invoice;
      try {
        invoice = await _supabase
            .from('invoices')
            .insert(invoiceRecord)
            .select()
            .single();
      } catch (e) {
        // Si falla por columnas inexistentes (type/original_invoice_id),
        // reintentar sin ellas
        if (e.toString().contains('column') || e.toString().contains('42703')) {
          invoiceRecord.remove('type');
          invoiceRecord.remove('original_invoice_id');
          invoiceRecord['invoice_number'] = await _generateInvoiceNumber();

          invoice = await _supabase
              .from('invoices')
              .insert(invoiceRecord)
              .select()
              .single();
        } else {
          rethrow;
        }
      }

      final invoiceId = (invoice['id'] as num).toInt();
      debugPrint(
        '[InvoiceService] Factura rectificativa creada: #$invoiceId ($invoiceNumber)',
      );

      // 5. Insertar items (con precios negativos)
      if (items.isNotEmpty) {
        final invoiceItems = items
            .map(
              (item) => <String, dynamic>{
                'invoice_id': invoiceId,
                'product_id': item.productId,
                'product_name': item.productName,
                'product_size': item.productSize,
                'quantity': item.quantity,
                'unit_price': -item.unitPrice.abs(),
                'line_total': -(item.unitPrice.abs() * item.quantity),
              },
            )
            .toList();

        await _supabase.from('invoice_items').insert(invoiceItems);
      }

      debugPrint(
        '[InvoiceService] ✅ Credit note completa para pedido #$orderId',
      );
      return invoice;
    } catch (e) {
      debugPrint('[InvoiceService] Error creando credit note: $e');
      return null;
    }
  }

  /// Intenta descargar el PDF de una factura desde la Web API.
  /// Retorna los bytes del PDF o null si falla.
  Future<List<int>?> fetchInvoicePdfBytes(int invoiceId) async {
    try {
      final url =
          '${AppConstants.webApiBaseUrl}/api/invoice/$invoiceId/pdf?download=true';
      debugPrint('[InvoiceService] Descargando PDF desde: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        debugPrint(
          '[InvoiceService] PDF descargado: ${response.bodyBytes.length} bytes',
        );
        return response.bodyBytes;
      }

      debugPrint(
        '[InvoiceService] Error descargando PDF: ${response.statusCode}',
      );
      return null;
    } catch (e) {
      debugPrint('[InvoiceService] Error descargando PDF: $e');
      return null;
    }
  }

  /// Restaura el stock de los productos devueltos.
  /// [items] lista de {product_id, quantity, size}
  Future<void> restoreStock(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final productId = item['product_id'] as int?;
      final quantity = item['quantity'] as int? ?? 0;
      final size = item['size'] as String?;

      if (productId == null || quantity == 0) continue;

      try {
        // Stock general vía RPC
        await _supabase.rpc(
          'increment_stock',
          params: {'product_id_param': productId, 'quantity_param': quantity},
        );

        // Stock por talla
        if (size != null && size.isNotEmpty) {
          try {
            await _supabase.rpc(
              'increment_product_size_stock',
              params: {
                'p_product_id': productId,
                'p_size': size,
                'p_quantity': quantity,
              },
            );
          } catch (_) {
            // Fallback manual si no existe el RPC
            final sizeData = await _supabase
                .from('product_sizes')
                .select('stock')
                .eq('product_id', productId)
                .eq('size', size)
                .maybeSingle();

            if (sizeData != null) {
              final currentStock = (sizeData['stock'] as num?)?.toInt() ?? 0;
              await _supabase
                  .from('product_sizes')
                  .update({'stock': currentStock + quantity})
                  .eq('product_id', productId)
                  .eq('size', size);
            }
          }
        }

        debugPrint(
          '[InvoiceService] Stock restaurado: producto=$productId, qty=$quantity, talla=$size',
        );
      } catch (e) {
        debugPrint(
          '[InvoiceService] Error restaurando stock producto=$productId: $e',
        );
      }
    }
  }
}
