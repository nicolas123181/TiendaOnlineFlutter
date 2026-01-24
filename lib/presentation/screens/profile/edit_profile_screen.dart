import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/error_widget.dart';

/// Pantalla para editar datos personales
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final profile = await ref.read(userProfileProvider.future);
    if (profile != null) {
      // Dividir nombre completo en nombre y apellido
      final nameParts = (profile.name ?? '').split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
      _lastNameController.text =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      _emailController.text = profile.email;
      _phoneController.text = profile.phone ?? '';
    }

    // Escuchar cambios
    _firstNameController.addListener(_onChanged);
    _lastNameController.addListener(_onChanged);
    _phoneController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).updateProfile(
            fullName:
                '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
            phone: _phoneController.text.trim(),
          );

      if (mounted) {
        showSuccessSnackBar(context, 'Perfil actualizado correctamente');
        context.pop();
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

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final confirm = await ConfirmDialog.show(
      context: context,
      title: 'Descartar cambios',
      message: '¿Estás seguro de que deseas salir sin guardar los cambios?',
      confirmText: 'Descartar',
      isDanger: true,
    );

    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Editar Perfil',
          showBackButton: true,
          actions: [
            if (_hasChanges)
              TextButton(
                onPressed: _isLoading ? null : _saveChanges,
                child: const Text('Guardar'),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.brandNavy,
                        child: Text(
                          _getInitials(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.brandGold,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _changePhoto,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Nombre
                const Text(
                  'Nombre',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstNameController,
                  decoration: _inputDecoration('Ej: Juan'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Apellido
                const Text(
                  'Apellido',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameController,
                  decoration: _inputDecoration('Ej: García'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El apellido es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email (solo lectura)
                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration('email@ejemplo.com').copyWith(
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    suffixIcon: const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 4),
                const Text(
                  'El email no puede ser modificado',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 16),

                // Teléfono
                const Text(
                  'Teléfono',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration('+34 612 345 678'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),

                // Botón guardar
                CustomButton(
                  text: 'Guardar Cambios',
                  onPressed: _hasChanges ? _saveChanges : null,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.brandNavy, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  String _getInitials() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();

    if (first.isEmpty && last.isEmpty) return 'U';
    if (first.isEmpty) return last[0].toUpperCase();
    if (last.isEmpty) return first[0].toUpperCase();

    return '${first[0]}${last[0]}'.toUpperCase();
  }

  void _changePhoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Abrir cámara
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Abrir galería
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text(
                'Eliminar foto',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Eliminar foto
              },
            ),
          ],
        ),
      ),
    );
  }
}
