import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';

/// Pantalla de gestión de direcciones
class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  bool _isLoading = true;
  List<Address> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    // Simular carga
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _addresses = [
          Address(
            id: '1',
            name: 'Casa',
            recipientName: 'Juan García',
            street: 'Calle Mayor 123',
            city: 'Madrid',
            postalCode: '28001',
            province: 'Madrid',
            country: 'España',
            phone: '+34 612 345 678',
            isDefault: true,
          ),
          Address(
            id: '2',
            name: 'Oficina',
            recipientName: 'Juan García',
            street: 'Av. de la Constitución 45, Piso 3',
            city: 'Madrid',
            postalCode: '28014',
            province: 'Madrid',
            country: 'España',
            phone: '+34 612 345 678',
            isDefault: false,
          ),
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final confirm = await ConfirmDialog.show(
      context: context,
      title: 'Eliminar dirección',
      message: '¿Estás seguro de que deseas eliminar esta dirección?',
      confirmText: 'Eliminar',
      isDanger: true,
    );

    if (confirm == true) {
      setState(() {
        _addresses.removeWhere((a) => a.id == addressId);
      });
      if (mounted) {
        showSuccessSnackBar(context, 'Dirección eliminada');
      }
    }
  }

  void _setAsDefault(String addressId) {
    setState(() {
      for (final address in _addresses) {
        address.isDefault = address.id == addressId;
      }
    });
    showSuccessSnackBar(context, 'Dirección principal actualizada');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mis Direcciones',
        showBackButton: true,
      ),
      body: _isLoading
          ? const LoadingScreen()
          : _addresses.isEmpty
              ? _buildEmptyState()
              : _buildAddressList(),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sin direcciones guardadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega una dirección para agilizar tus compras',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _addresses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return _AddressCard(
          address: address,
          onEdit: () async {
            final result = await context.push('/addresses/${address.id}/edit');
            if (result == true) {
              _loadAddresses();
            }
          },
          onDelete: () => _deleteAddress(address.id),
          onSetDefault: () => _setAsDefault(address.id),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: CustomButton(
        text: 'Agregar Dirección',
        onPressed: () async {
          final result = await context.push('/addresses/new');
          if (result == true) {
            _loadAddresses();
          }
        },
        icon: Icons.add,
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: address.isDefault ? AppColors.brandNavy : AppColors.border,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.brandNavy,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      address.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        color: AppColors.brandNavy,
                        child: const Text(
                          'Principal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  address.recipientName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  address.street,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '${address.postalCode} ${address.city}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '${address.province}, ${address.country}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                if (address.phone != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        address.phone!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onEdit,
                    child: const Text('Editar'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onDelete,
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
                if (!address.isDefault) ...[
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.border,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: onSetDefault,
                      child: const Text('Principal'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modelo de dirección
class Address {
  final String id;
  final String name;
  final String recipientName;
  final String street;
  final String city;
  final String postalCode;
  final String province;
  final String country;
  final String? phone;
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.recipientName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.province,
    required this.country,
    this.phone,
    this.isDefault = false,
  });
}
