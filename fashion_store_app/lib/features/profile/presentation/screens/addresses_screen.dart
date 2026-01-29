import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../providers/addresses_provider.dart';

/// Pantalla de gestión de direcciones
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(userAddressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MIS DIRECCIONES')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressForm(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Añadir'),
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes direcciones guardadas',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddressForm(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir dirección'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(userAddressesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _AddressCard(
                  address: address,
                  onEdit: () =>
                      _showAddressForm(context, ref, address: address),
                  onDelete: () => _confirmDelete(context, ref, address),
                  onSetDefault: () => ref
                      .read(addressesNotifierProvider.notifier)
                      .setAsDefault(address.id),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error al cargar direcciones',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(userAddressesProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressForm(
    BuildContext context,
    WidgetRef ref, {
    ShippingAddress? address,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        address: address,
        onSave: (data) async {
          if (address != null) {
            await ref
                .read(addressesNotifierProvider.notifier)
                .updateAddress(
                  id: address.id,
                  fullName: data['fullName'],
                  address: data['address'],
                  postalCode: data['postalCode'],
                  city: data['city'],
                  phone: data['phone'],
                  isDefault: data['isDefault'],
                );
          } else {
            await ref
                .read(addressesNotifierProvider.notifier)
                .addAddress(
                  fullName: data['fullName']!,
                  address: data['address']!,
                  postalCode: data['postalCode']!,
                  city: data['city']!,
                  phone: data['phone']!,
                  isDefault: data['isDefault'] ?? false,
                );
          }
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ShippingAddress address,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar dirección'),
        content: Text(
          '¿Estás seguro de que quieres eliminar la dirección de ${address.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(addressesNotifierProvider.notifier)
                  .deleteAddress(address.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final ShippingAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: address.isDefault ? AppColors.primary : AppColors.border,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.fullName,
                    style: AppTextStyles.labelLarge,
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Principal',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(address.address, style: AppTextStyles.bodyMedium),
            Text(
              '${address.postalCode} ${address.city}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  address.phone,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!address.isDefault)
                  OutlinedButton.icon(
                    onPressed: onSetDefault,
                    icon: const Icon(Icons.star_border, size: 18),
                    label: const Text('Principal'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onDelete,
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final ShippingAddress? address;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const _AddressFormSheet({this.address, required this.onSave});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _cityController;
  late final TextEditingController _phoneController;
  late bool _isDefault;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.fullName);
    _addressController = TextEditingController(text: widget.address?.address);
    _postalCodeController = TextEditingController(
      text: widget.address?.postalCode,
    );
    _cityController = TextEditingController(text: widget.address?.city);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.onSave({
        'fullName': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
        'city': _cityController.text.trim(),
        'phone': _phoneController.text.trim(),
        'isDefault': _isDefault,
      });
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                widget.address != null ? 'Editar dirección' : 'Nueva dirección',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _postalCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Código postal',
                        prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                title: const Text('Dirección principal'),
                subtitle: const Text('Usar como predeterminada'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        widget.address != null
                            ? 'Guardar cambios'
                            : 'Añadir dirección',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
