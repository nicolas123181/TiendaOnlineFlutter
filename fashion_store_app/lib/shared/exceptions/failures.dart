import 'package:fpdart/fpdart.dart';

/// Clase base para manejar errores en la aplicación
/// Usamos Failures en lugar de Exceptions para control funcional del flujo
sealed class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({required this.message, this.code, this.originalError});

  @override
  String toString() => 'Failure($code): $message';
}

/// Error de conexión a la red
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Error de conexión. Verifica tu conexión a internet.',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Error del servidor
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'Error del servidor. Inténtalo de nuevo más tarde.',
    super.code = 'SERVER_ERROR',
    super.originalError,
    this.statusCode,
  });
}

/// Error de autenticación
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Error de autenticación.',
    super.code = 'AUTH_ERROR',
    super.originalError,
  });

  /// Credenciales inválidas
  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Email o contraseña incorrectos.',
    code: 'INVALID_CREDENTIALS',
  );

  /// Usuario no encontrado
  factory AuthFailure.userNotFound() => const AuthFailure(
    message: 'Usuario no encontrado.',
    code: 'USER_NOT_FOUND',
  );

  /// Sesión expirada
  factory AuthFailure.sessionExpired() => const AuthFailure(
    message: 'Tu sesión ha expirado. Inicia sesión de nuevo.',
    code: 'SESSION_EXPIRED',
  );

  /// Email ya registrado
  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    message: 'Este email ya está registrado.',
    code: 'EMAIL_IN_USE',
  );

  /// Contraseña débil
  factory AuthFailure.weakPassword() => const AuthFailure(
    message: 'La contraseña es demasiado débil. Usa al menos 6 caracteres.',
    code: 'WEAK_PASSWORD',
  );

  /// Sin permisos
  factory AuthFailure.unauthorized() => const AuthFailure(
    message: 'No tienes permisos para realizar esta acción.',
    code: 'UNAUTHORIZED',
  );
}

/// Error de caché/almacenamiento local
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Error al acceder a los datos locales.',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// Error de validación de datos
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    super.message = 'Error de validación.',
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    this.fieldErrors,
  });

  factory ValidationFailure.emptyField(String fieldName) => ValidationFailure(
    message: 'El campo $fieldName es obligatorio.',
    code: 'EMPTY_FIELD',
    fieldErrors: {fieldName: 'Campo obligatorio'},
  );

  factory ValidationFailure.invalidEmail() => const ValidationFailure(
    message: 'El email no es válido.',
    code: 'INVALID_EMAIL',
    fieldErrors: {'email': 'Email inválido'},
  );

  factory ValidationFailure.invalidPhone() => const ValidationFailure(
    message: 'El teléfono no es válido.',
    code: 'INVALID_PHONE',
    fieldErrors: {'phone': 'Teléfono inválido'},
  );
}

/// Error de producto/stock
class ProductFailure extends Failure {
  const ProductFailure({
    super.message = 'Error con el producto.',
    super.code = 'PRODUCT_ERROR',
    super.originalError,
  });

  factory ProductFailure.notFound() => const ProductFailure(
    message: 'Producto no encontrado.',
    code: 'PRODUCT_NOT_FOUND',
  );

  factory ProductFailure.outOfStock() =>
      const ProductFailure(message: 'Producto agotado.', code: 'OUT_OF_STOCK');

  factory ProductFailure.insufficientStock(int available) => ProductFailure(
    message: 'Solo hay $available unidades disponibles.',
    code: 'INSUFFICIENT_STOCK',
  );
}

/// Error de carrito
class CartFailure extends Failure {
  const CartFailure({
    super.message = 'Error en el carrito.',
    super.code = 'CART_ERROR',
    super.originalError,
  });

  factory CartFailure.empty() =>
      const CartFailure(message: 'El carrito está vacío.', code: 'CART_EMPTY');

  factory CartFailure.itemNotFound() => const CartFailure(
    message: 'Producto no encontrado en el carrito.',
    code: 'ITEM_NOT_FOUND',
  );
}

/// Error de pago
class PaymentFailure extends Failure {
  const PaymentFailure({
    super.message = 'Error en el pago.',
    super.code = 'PAYMENT_ERROR',
    super.originalError,
  });

  factory PaymentFailure.declined() => const PaymentFailure(
    message: 'El pago fue rechazado. Verifica los datos de tu tarjeta.',
    code: 'PAYMENT_DECLINED',
  );

  factory PaymentFailure.cancelled() => const PaymentFailure(
    message: 'El pago fue cancelado.',
    code: 'PAYMENT_CANCELLED',
  );
}

/// Error de subida/storage
class StorageFailure extends Failure {
  const StorageFailure({
    super.message = 'Error al subir el archivo.',
    super.code = 'STORAGE_ERROR',
    super.originalError,
  });

  factory StorageFailure.fileTooLarge(int maxSizeMB) => StorageFailure(
    message: 'El archivo es demasiado grande. Máximo ${maxSizeMB}MB.',
    code: 'FILE_TOO_LARGE',
  );

  factory StorageFailure.invalidFormat(List<String> allowedFormats) =>
      StorageFailure(
        message: 'Formato no válido. Usa: ${allowedFormats.join(", ")}.',
        code: 'INVALID_FORMAT',
      );
}

/// Error desconocido
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Ha ocurrido un error inesperado.',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
  });
}

/// Type alias para Either con Failure
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef EitherFailure<T> = Either<Failure, T>;
