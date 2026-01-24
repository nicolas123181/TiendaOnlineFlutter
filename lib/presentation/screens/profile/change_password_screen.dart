import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/error_widget.dart';

/// Pantalla para cambiar contraseña
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).updatePassword(
            _newPasswordController.text,
          );

      if (mounted) {
        await SuccessDialog.show(
          context: context,
          title: '¡Contraseña actualizada!',
          message: 'Tu contraseña ha sido cambiada exitosamente.',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Cambiar Contraseña',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.info.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tu contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas y números.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contraseña actual
              const Text(
                'Contraseña actual',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureCurrent = !_obscureCurrent);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu contraseña actual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Nueva contraseña
              const Text(
                'Nueva contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureNew = !_obscureNew);
                    },
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa una nueva contraseña';
                  }
                  if (!_isPasswordValid(value)) {
                    return 'La contraseña no cumple los requisitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Indicadores de requisitos
              _PasswordRequirement(
                text: 'Mínimo 8 caracteres',
                isMet: _newPasswordController.text.length >= 8,
              ),
              _PasswordRequirement(
                text: 'Una letra mayúscula',
                isMet: _newPasswordController.text.contains(RegExp(r'[A-Z]')),
              ),
              _PasswordRequirement(
                text: 'Una letra minúscula',
                isMet: _newPasswordController.text.contains(RegExp(r'[a-z]')),
              ),
              _PasswordRequirement(
                text: 'Un número',
                isMet: _newPasswordController.text.contains(RegExp(r'[0-9]')),
              ),
              const SizedBox(height: 24),

              // Confirmar contraseña
              const Text(
                'Confirmar nueva contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirma tu nueva contraseña';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón cambiar
              CustomButton(
                text: 'Cambiar Contraseña',
                onPressed: _changePassword,
                isLoading: _isLoading,
              ),
            ],
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
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
