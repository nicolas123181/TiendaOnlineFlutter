import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/error_widget.dart';

/// Pantalla de recuperación de contraseña
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).resetPassword(
          _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Mostrar error si existe
    ref.listen<AuthNotifierState>(authProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        showErrorSnackBar(context, next.error!);
      }
      if (next.successMessage != null &&
          previous?.successMessage != next.successMessage) {
        showSuccessSnackBar(context, next.successMessage!);
        if (mounted) {
          setState(() => _emailSent = true);
        }
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent
              ? _buildSuccessContent()
              : _buildFormContent(authState),
        ),
      ),
    );
  }

  Widget _buildFormContent(AuthNotifierState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.brandNavy.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.lock_reset_outlined,
              color: AppColors.brandNavy,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),

          // Título
          const Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No te preocupes, te enviaremos instrucciones para restablecerla.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),

          // Email
          CustomTextField(
            controller: _emailController,
            label: 'Correo electrónico',
            hint: 'tu@email.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.email_outlined),
            onSubmitted: (_) => _handleResetPassword(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Ingresa un email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Botón de enviar
          CustomButton(
            text: 'Enviar Instrucciones',
            onPressed: _handleResetPassword,
            isLoading: authState.isLoading,
            width: double.infinity,
          ),
          const SizedBox(height: 24),

          // Volver al login
          Center(
            child: GestureDetector(
              onTap: () => context.go('/login'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Volver al inicio de sesión',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        // Icono de éxito
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: AppColors.success,
            size: 40,
          ),
        ),
        const SizedBox(height: 32),

        // Título
        const Text(
          '¡Revisa tu bandeja de entrada!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Descripción
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Hemos enviado instrucciones para restablecer tu contraseña a ${_emailController.text}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),

        // Botón de ir al login
        CustomButton(
          text: 'Ir al Inicio de Sesión',
          onPressed: () => context.go('/login'),
          width: double.infinity,
        ),
        const SizedBox(height: 24),

        // Reenviar email
        const Text(
          '¿No recibiste el email?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => _emailSent = false);
          },
          child: const Text(
            'Intentar de nuevo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.brandNavy,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Info adicional
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            border: Border.all(color: AppColors.info.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'El enlace expira en 1 hora',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Revisa también tu carpeta de spam si no encuentras el email.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
