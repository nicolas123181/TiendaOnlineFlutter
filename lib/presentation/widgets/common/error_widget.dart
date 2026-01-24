import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';
import 'custom_button.dart';

/// Widget de error genérico
class ErrorWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? retryText;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.error_outline,
    this.retryText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: retryText ?? 'Reintentar',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de error de conexión
class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ConnectionErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.wifi_off,
      title: 'Sin conexión',
      subtitle: 'Comprueba tu conexión a internet e inténtalo de nuevo',
      onRetry: onRetry,
    );
  }
}

/// Widget de error del servidor
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.cloud_off,
      title: 'Error del servidor',
      subtitle: 'Algo salió mal. Por favor, inténtalo más tarde',
      onRetry: onRetry,
    );
  }
}

/// Widget de no encontrado
class NotFoundWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onGoBack;

  const NotFoundWidget({
    super.key,
    this.message,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.search_off,
      title: 'No encontrado',
      subtitle:
          message ?? 'El contenido que buscas no existe o ha sido eliminado',
      retryText: 'Volver',
      onRetry: onGoBack,
    );
  }
}

/// Widget de sesión expirada
class SessionExpiredWidget extends StatelessWidget {
  final VoidCallback? onLogin;

  const SessionExpiredWidget({
    super.key,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      icon: Icons.lock_clock,
      title: 'Sesión expirada',
      subtitle: 'Tu sesión ha caducado. Por favor, inicia sesión de nuevo',
      retryText: 'Iniciar sesión',
      onRetry: onLogin,
    );
  }
}

/// Widget de mantenimiento
class MaintenanceWidget extends StatelessWidget {
  const MaintenanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ErrorWidget(
      icon: Icons.construction,
      title: 'En mantenimiento',
      subtitle: 'Estamos mejorando la aplicación. Vuelve pronto',
    );
  }
}

/// Snackbar de error
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}

/// Snackbar de éxito
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Snackbar de información
void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.info,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Snackbar con acción
void showActionSnackBar(
  BuildContext context,
  String message, {
  required String actionLabel,
  required VoidCallback onAction,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: AppColors.brandNavy,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: actionLabel,
        textColor: AppColors.brandGold,
        onPressed: onAction,
      ),
    ),
  );
}
