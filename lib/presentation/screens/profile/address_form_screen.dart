import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';

/// Pantalla para agregar o editar una dirección
class AddressFormScreen extends ConsumerStatefulWidget {
  final String? addressId;

  const AddressFormScreen({
    super.key,
    this.addressId,
  });

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _recipientController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _provinceController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedCountry = 'España';
  bool _isDefault = false;
  bool _isLoading = false;

  bool get isEditing => widget.addressId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadAddress();
    }
  }

  Future<void> _loadAddress() async {
    // TODO: Cargar dirección existente desde el provider
    // Simular datos para edición
    _nameController.text = 'Casa';
    _recipientController.text = 'Juan García';
    _streetController.text = 'Calle Mayor 123';
    _cityController.text = 'Madrid';
    _postalCodeController.text = '28001';
    _provinceController.text = 'Madrid';
    _phoneController.text = '+34 612 345 678';
    _isDefault = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _recipientController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _provinceController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Guardar dirección via provider
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Dirección actualizada' : 'Dirección guardada',
            ),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
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
      appBar: CustomAppBar(
        title: isEditing ? 'Editar Dirección' : 'Nueva Dirección',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la dirección
              _FormLabel('Nombre de la dirección'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Ej: Casa, Oficina'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Destinatario
              _FormLabel('Nombre del destinatario'),
              TextFormField(
                controller: _recipientController,
                decoration: _inputDecoration('Nombre completo'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dirección
              _FormLabel('Dirección'),
              TextFormField(
                controller: _streetController,
                decoration: _inputDecoration('Calle, número, piso, puerta'),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ciudad y código postal
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FormLabel('Ciudad'),
                        TextFormField(
                          controller: _cityController,
                          decoration: _inputDecoration('Ciudad'),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FormLabel('C.P.'),
                        TextFormField(
                          controller: _postalCodeController,
                          decoration: _inputDecoration('28001'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Requerido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Provincia
              _FormLabel('Provincia'),
              TextFormField(
                controller: _provinceController,
                decoration: _inputDecoration('Provincia'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // País
              _FormLabel('País'),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: _inputDecoration(''),
                items: const [
                  DropdownMenuItem(value: 'España', child: Text('España')),
                  DropdownMenuItem(value: 'Portugal', child: Text('Portugal')),
                  DropdownMenuItem(value: 'Francia', child: Text('Francia')),
                  DropdownMenuItem(value: 'Italia', child: Text('Italia')),
                  DropdownMenuItem(value: 'Alemania', child: Text('Alemania')),
                ],
                onChanged: (value) {
                  setState(() => _selectedCountry = value!);
                },
              ),
              const SizedBox(height: 16),

              // Teléfono
              _FormLabel('Teléfono (opcional)'),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('+34 612 345 678'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Dirección por defecto
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                ),
                child: CheckboxListTile(
                  value: _isDefault,
                  onChanged: (value) {
                    setState(() => _isDefault = value ?? false);
                  },
                  title: const Text('Establecer como dirección principal'),
                  subtitle: const Text(
                    'Esta será tu dirección predeterminada para envíos',
                    style: TextStyle(fontSize: 12),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              const SizedBox(height: 32),

              // Botón guardar
              CustomButton(
                text: isEditing ? 'Guardar Cambios' : 'Agregar Dirección',
                onPressed: _saveAddress,
                isLoading: _isLoading,
              ),
            ],
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
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
