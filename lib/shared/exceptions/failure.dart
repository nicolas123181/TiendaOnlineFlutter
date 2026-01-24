/// Clases de error personalizadas para manejo estructurado de errores
/// Siguiendo el patrón de Clean Architecture
library;

/// Clase base abstracta para todos los tipos de error
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'Failure: $message (code: $code)';
}

/// Error de servidor/backend
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory ServerFailure.fromException(dynamic e) {
    return ServerFailure(
      message: e.toString(),
      originalError: e,
    );
  }

  factory ServerFailure.fromSupabaseError(dynamic error) {
    final message = error?.message ?? 'Error de servidor desconocido';
    final code = error?.code?.toString();
    return ServerFailure(
      message: message,
      code: code,
      originalError: error,
    );
  }
}

/// Error de conexión de red
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Sin conexión a internet. Verifica tu conexión.',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'La conexión tardó demasiado. Intenta de nuevo.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkFailure.noInternet() {
    return const NetworkFailure(
      message: 'No hay conexión a internet.',
      code: 'NO_INTERNET',
    );
  }
}

/// Error de caché/almacenamiento local
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Error al acceder al almacenamiento local.',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });

  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'Datos no encontrados en caché.',
      code: 'NOT_FOUND',
    );
  }

  factory CacheFailure.writeError() {
    return const CacheFailure(
      message: 'Error al guardar datos localmente.',
      code: 'WRITE_ERROR',
    );
  }
}

/// Error de autenticación
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Email o contraseña incorrectos.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      message: 'Tu sesión ha expirado. Inicia sesión de nuevo.',
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthFailure.unauthorized() {
    return const AuthFailure(
      message: 'No tienes permisos para realizar esta acción.',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthFailure.emailNotVerified() {
    return const AuthFailure(
      message: 'Por favor verifica tu email antes de continuar.',
      code: 'EMAIL_NOT_VERIFIED',
    );
  }

  factory AuthFailure.weakPassword() {
    return const AuthFailure(
      message: 'La contraseña debe tener al menos 6 caracteres.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthFailure.emailInUse() {
    return const AuthFailure(
      message: 'Este email ya está registrado.',
      code: 'EMAIL_IN_USE',
    );
  }
}

/// Error de validación de datos
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
  });

  factory ValidationFailure.required(String fieldName) {
    return ValidationFailure(
      message: '$fieldName es obligatorio.',
      fieldErrors: {fieldName.toLowerCase(): 'Campo obligatorio'},
    );
  }

  factory ValidationFailure.invalid(String fieldName, String reason) {
    return ValidationFailure(
      message: '$fieldName inválido: $reason',
      fieldErrors: {fieldName.toLowerCase(): reason},
    );
  }
}

/// Error de operación de negocio
class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory BusinessFailure.insufficientStock() {
    return const BusinessFailure(
      message: 'No hay suficiente stock disponible.',
      code: 'INSUFFICIENT_STOCK',
    );
  }

  factory BusinessFailure.orderNotFound() {
    return const BusinessFailure(
      message: 'Pedido no encontrado.',
      code: 'ORDER_NOT_FOUND',
    );
  }

  factory BusinessFailure.productNotFound() {
    return const BusinessFailure(
      message: 'Producto no encontrado.',
      code: 'PRODUCT_NOT_FOUND',
    );
  }

  factory BusinessFailure.couponInvalid(String reason) {
    return BusinessFailure(
      message: reason,
      code: 'COUPON_INVALID',
    );
  }

  factory BusinessFailure.paymentFailed(String reason) {
    return BusinessFailure(
      message: 'Error en el pago: $reason',
      code: 'PAYMENT_FAILED',
    );
  }
}

/// Extension para convertir Failures a mensajes amigables
extension FailureExtension on Failure {
  /// Obtiene un mensaje amigable para mostrar al usuario
  String get userMessage {
    switch (this) {
      case NetworkFailure():
        return message;
      case AuthFailure():
        return message;
      case ServerFailure():
        return 'Ha ocurrido un error. Intenta de nuevo.';
      case CacheFailure():
        return 'Error al cargar datos. Intenta de nuevo.';
      case ValidationFailure():
        return message;
      case BusinessFailure():
        return message;
      default:
        return 'Ha ocurrido un error inesperado.';
    }
  }

  /// Verifica si el error requiere reconexión
  bool get requiresReconnection {
    return this is NetworkFailure ||
        (this is AuthFailure &&
            (this as AuthFailure).code == 'SESSION_EXPIRED');
  }
}
