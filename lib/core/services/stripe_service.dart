import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Servicio de Stripe para pagos
class StripeService {
  StripeService._();

  static final StripeService _instance = StripeService._();
  static StripeService get instance => _instance;

  /// Inicializa Stripe con la clave publicable
  static Future<void> initialize() async {
    final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (publishableKey == null || publishableKey.isEmpty) {
      throw Exception('STRIPE_PUBLISHABLE_KEY no está configurada');
    }

    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Crea un Payment Intent en el servidor
  /// Esto debería llamar a una Edge Function de Supabase
  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount, // En centavos
    required String currency,
    required String customerEmail,
    Map<String, String>? metadata,
  }) async {
    try {
      // Esta URL debería ser tu Edge Function de Supabase
      // Por ahora, simularemos la respuesta para desarrollo
      // En producción, debes implementar la Edge Function

      // TODO: Implementar llamada a Edge Function
      // final response = await _dio.post(
      //   'https://tu-proyecto.supabase.co/functions/v1/create-payment-intent',
      //   data: {
      //     'amount': amount,
      //     'currency': currency,
      //     'customer_email': customerEmail,
      //     'metadata': metadata,
      //   },
      // );
      // return response.data;

      // Para desarrollo/pruebas, retornamos datos mock
      // IMPORTANTE: En producción, esto debe ser una llamada real al servidor
      throw UnimplementedError(
        'Debes implementar la Edge Function de Supabase para crear Payment Intents. '
        'Consulta la documentación de Stripe para más información.',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Confirma el pago con la tarjeta
  Future<PaymentIntent> confirmPayment({
    required String clientSecret,
    BillingDetails? billingDetails,
  }) async {
    try {
      // Crear los parámetros del método de pago
      final paymentMethodParams = PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      );

      // Confirmar el pago
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: paymentMethodParams,
      );

      return paymentIntent;
    } on StripeException catch (e) {
      throw StripePaymentException(
        code: e.error.code.name,
        message: e.error.localizedMessage ?? 'Error al procesar el pago',
      );
    }
  }

  /// Presenta la hoja de pago de Stripe
  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      throw StripePaymentException(
        code: e.error.code.name,
        message: e.error.localizedMessage ?? 'El pago fue cancelado',
      );
    }
  }

  /// Inicializa la hoja de pago
  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String merchantDisplayName,
    String? customerEmail,
    BillingDetails? billingDetails,
    bool allowsDelayedPaymentMethods = false,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: merchantDisplayName,
        style: ThemeMode.system,
        billingDetails: billingDetails,
        allowsDelayedPaymentMethods: allowsDelayedPaymentMethods,
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Color(0xFF1A2744),
          ),
          shapes: PaymentSheetShape(
            borderRadius: 0,
          ),
        ),
      ),
    );
  }

  /// Crea un reembolso (debe llamarse desde el servidor)
  /// Esta función es para referencia - debe implementarse en una Edge Function
  Future<Map<String, dynamic>> createRefund({
    required String paymentIntentId,
    int? amount, // Monto parcial en centavos, null para reembolso total
    String? reason,
  }) async {
    // TODO: Implementar llamada a Edge Function para reembolsos
    throw UnimplementedError(
      'Debes implementar la Edge Function de Supabase para crear reembolsos.',
    );
  }

  /// Valida el número de tarjeta (básico)
  bool isValidCardNumber(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'\s'), '');
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }
    return _luhnCheck(cleanNumber);
  }

  /// Algoritmo de Luhn para validar tarjetas
  bool _luhnCheck(String number) {
    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Obtiene el tipo de tarjeta por el número
  CardBrand getCardBrand(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'\s'), '');

    if (cleanNumber.startsWith('4')) {
      return CardBrand.Visa;
    } else if (_matchesPrefixes(cleanNumber, ['51', '52', '53', '54', '55']) ||
        _isInRange(cleanNumber, 2221, 2720)) {
      return CardBrand.Mastercard;
    } else if (_matchesPrefixes(cleanNumber, ['34', '37'])) {
      return CardBrand.Amex;
    } else if (_matchesPrefixes(cleanNumber,
        ['6011', '644', '645', '646', '647', '648', '649', '65'])) {
      return CardBrand.Discover;
    }

    return CardBrand.Unknown;
  }

  bool _matchesPrefixes(String number, List<String> prefixes) {
    return prefixes.any((prefix) => number.startsWith(prefix));
  }

  bool _isInRange(String number, int start, int end) {
    if (number.length < 4) return false;
    final prefix = int.tryParse(number.substring(0, 4));
    if (prefix == null) return false;
    return prefix >= start && prefix <= end;
  }
}

/// Tipos de tarjeta soportados
enum CardBrand {
  Visa,
  Mastercard,
  Amex,
  Discover,
  Unknown,
}

/// Excepción personalizada para errores de pago
class StripePaymentException implements Exception {
  final String code;
  final String message;

  StripePaymentException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'StripePaymentException: [$code] $message';
}

/// Resultado de un pago
class PaymentResult {
  final bool success;
  final String? paymentIntentId;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.paymentIntentId,
    this.errorMessage,
  });

  factory PaymentResult.success(String paymentIntentId) {
    return PaymentResult(
      success: true,
      paymentIntentId: paymentIntentId,
    );
  }

  factory PaymentResult.failure(String errorMessage) {
    return PaymentResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}
