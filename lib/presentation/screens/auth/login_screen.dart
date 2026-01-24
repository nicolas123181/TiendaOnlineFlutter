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

/// Pantalla de inicio de sesión
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    final user = ref.read(currentUserProvider);
    if (user != null && mounted) {
      context.go('/home');
    }
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
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bienvenido de nuevo a VANTAGE',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

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
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  onSubmitted: (_) => _handleLogin(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Recordarme y Olvidé contraseña
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _rememberMe
                                    ? AppColors.brandNavy
                                    : AppColors.border,
                                width: _rememberMe ? 2 : 1,
                              ),
                              color: _rememberMe
                                  ? AppColors.brandNavy
                                  : Colors.transparent,
                            ),
                            child: _rememberMe
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Recordarme',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Olvidé contraseña
                    GestureDetector(
                      onTap: () => context.push('/forgot-password'),
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.brandNavy,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Botón de login
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: _handleLogin,
                  isLoading: authState.isLoading,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),

                // Divider
                const DividerWithText(text: 'o continúa con'),
                const SizedBox(height: 24),

                // Social login buttons
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onPressed: () {
                          // TODO: Implementar Google Sign In
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
                          // TODO: Implementar Apple Sign In
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

                // Crear cuenta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: const Text(
                        'Crear cuenta',
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
              ],
            ),
          ),
        ),
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
