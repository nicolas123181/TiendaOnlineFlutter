import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/misc_widgets.dart';

/// Pantalla de registro
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _acceptNewsletter = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      showErrorSnackBar(
        context,
        'Debes aceptar los términos y condiciones',
      );
      return;
    }

    await ref.read(authProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
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
          context.go('/login');
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Únete a la experiencia VANTAGE',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Nombre completo
                CustomTextField(
                  controller: _nameController,
                  label: 'Nombre completo',
                  hint: 'Juan Pérez',
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    if (value.length < 2) {
                      return 'El nombre debe tener al menos 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  hint: 'tu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
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
                const SizedBox(height: 20),

                // Contraseña
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  hint: '••••••••',
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Debe contener al menos una mayúscula';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Debe contener al menos un número';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirmar contraseña
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar contraseña',
                  hint: '••••••••',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  onSubmitted: (_) => _handleRegister(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Requisitos de contraseña
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tu contraseña debe tener:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PasswordRequirement(
                        text: 'Al menos 8 caracteres',
                        isMet: _passwordController.text.length >= 8,
                      ),
                      _PasswordRequirement(
                        text: 'Una letra mayúscula',
                        isMet:
                            RegExp(r'[A-Z]').hasMatch(_passwordController.text),
                      ),
                      _PasswordRequirement(
                        text: 'Un número',
                        isMet:
                            RegExp(r'[0-9]').hasMatch(_passwordController.text),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Términos y condiciones
                _CheckboxTile(
                  value: _acceptTerms,
                  onChanged: (value) =>
                      setState(() => _acceptTerms = value ?? false),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Acepto los '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => context.push('/terms'),
                            child: const Text(
                              'Términos y Condiciones',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.brandNavy,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' y la '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => context.push('/privacy'),
                            child: const Text(
                              'Política de Privacidad',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.brandNavy,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Newsletter
                _CheckboxTile(
                  value: _acceptNewsletter,
                  onChanged: (value) =>
                      setState(() => _acceptNewsletter = value ?? false),
                  child: const Text(
                    'Quiero recibir ofertas exclusivas y novedades por email',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Botón de registro
                CustomButton(
                  text: 'Crear Cuenta',
                  onPressed: _handleRegister,
                  isLoading: authState.isLoading,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),

                // Divider
                const DividerWithText(text: 'o regístrate con'),
                const SizedBox(height: 24),

                // Social login buttons
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onPressed: () {
                          showInfoSnackBar(
                            context,
                            'Google Sign In próximamente',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SocialButton(
                        icon: Icons.apple,
                        label: 'Apple',
                        onPressed: () {
                          showInfoSnackBar(
                            context,
                            'Apple Sign In próximamente',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Ya tengo cuenta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes cuenta? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandNavy,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isMet;

  const _PasswordRequirement({
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isMet ? AppColors.success : AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? AppColors.success : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget child;

  const _CheckboxTile({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: value ? AppColors.brandNavy : AppColors.border,
                width: value ? 2 : 1,
              ),
              color: value ? AppColors.brandNavy : Colors.transparent,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.border),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
