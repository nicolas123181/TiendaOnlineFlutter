// Pantallas adicionales del Admin - Cupones, Usuarios, Newsletter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../providers/coupons_provider.dart';
import '../providers/users_provider.dart';
import '../providers/newsletter_provider.dart';
import '../../data/models/coupon.dart';
import '../../data/models/admin_stats.dart';

/// Pantalla de Gestión de Cupones
class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(couponsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Cupones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCouponDialog(context, ref),
          ),
        ],
      ),
      body: couponsAsync.when(
        data: (coupons) => coupons.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_offer, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No hay cupones creados'),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return _CouponCard(coupon: coupons[index]);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCreateCouponDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => _CreateCouponDialog());
  }
}

class _CouponCard extends ConsumerWidget {
  final Coupon coupon;

  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coupon.code,
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: coupon.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    coupon.isActive ? 'ACTIVO' : 'INACTIVO',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Descuento: ${coupon.displayDiscount}',
              style: AppTextStyles.labelLarge,
            ),
            Text(
              'Compra mínima: ${(coupon.minPurchase / 100).toStringAsFixed(2)} €',
              style: AppTextStyles.bodySmall,
            ),
            if (coupon.maxUses != null)
              Text(
                'Usos: ${coupon.currentUses}/${coupon.maxUses}',
                style: AppTextStyles.bodySmall,
              ),
            if (coupon.endDate != null)
              Text(
                'Válido hasta: ${DateFormat('dd/MM/yyyy').format(coupon.endDate!)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: coupon.isExpired ? Colors.red : Colors.green,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(couponActionsProvider)
                        .toggleCoupon(coupon.id, coupon.isActive);
                  },
                  child: Text(coupon.isActive ? 'Desactivar' : 'Activar'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(couponActionsProvider).deleteCoupon(coupon.id);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateCouponDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateCouponDialog> createState() =>
      _CreateCouponDialogState();
}

class _CreateCouponDialogState extends ConsumerState<_CreateCouponDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _minPurchaseController = TextEditingController();
  final _maxUsesController = TextEditingController();
  final _maxUsesPerUserController = TextEditingController();

  String _discountType = 'percentage';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _codeController.dispose();
    _valueController.dispose();
    _minPurchaseController.dispose();
    _maxUsesController.dispose();
    _maxUsesPerUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Cupón'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Código del cupón',
                  hintText: 'VERANO2026',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un código';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _discountType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de descuento',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'percentage',
                    child: Text('Porcentaje'),
                  ),
                  DropdownMenuItem(value: 'fixed', child: Text('Monto fijo')),
                ],
                onChanged: (value) {
                  setState(() {
                    _discountType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: _discountType == 'percentage'
                      ? 'Porcentaje (%)'
                      : 'Monto (€)',
                  hintText: _discountType == 'percentage' ? '10' : '5.00',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minPurchaseController,
                decoration: const InputDecoration(
                  labelText: 'Compra mínima (€)',
                  hintText: '0',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxUsesController,
                decoration: const InputDecoration(
                  labelText: 'Usos máximos (opcional)',
                  hintText: 'Ilimitado',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxUsesPerUserController,
                decoration: const InputDecoration(
                  labelText: 'Usos máximos por usuario (opcional)',
                  hintText: 'Ilimitado',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _createCoupon, child: const Text('Crear')),
      ],
    );
  }

  void _createCoupon() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(couponActionsProvider)
          .createCoupon(
            code: _codeController.text,
            discountType: _discountType,
            discountValue: int.parse(_valueController.text),
            minPurchase: int.tryParse(_minPurchaseController.text) ?? 0,
            maxUses: _maxUsesController.text.isNotEmpty
                ? int.parse(_maxUsesController.text)
                : null,
            maxUsesPerUser: _maxUsesPerUserController.text.isNotEmpty
                ? int.parse(_maxUsesPerUserController.text)
                : null,
            startDate: _startDate,
            endDate: _endDate,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

/// Pantalla de Gestión de Usuarios
class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStatsProvider);
    final totalStatsAsync = ref.watch(usersTotalStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: Column(
        children: [
          // Stats Cards
          totalStatsAsync.when(
            data: (stats) => Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.people,
                      label: 'Clientes Únicos',
                      value: '${stats['total_users']}',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.shopping_bag,
                      label: 'Pedidos Totales',
                      value: '${stats['total_orders']}',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.email,
                      label: 'Suscriptores',
                      value: '${stats['total_subscribers']}',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          // Users List
          Expanded(
            child: usersAsync.when(
              data: (users) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _UserCard(user: users[index]);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserStats user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.name, style: AppTextStyles.labelLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: AppTextStyles.bodySmall),
            Text(
              '${user.ordersCount} pedidos',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.green),
            ),
          ],
        ),
        trailing: user.isNewsletterSubscriber
            ? const Icon(Icons.email, color: Colors.purple)
            : null,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Pantalla de Newsletter
class AdminNewsletterScreen extends ConsumerWidget {
  const AdminNewsletterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribersAsync = ref.watch(newsletterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsletter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // TODO: Implementar envío de newsletter
            },
          ),
        ],
      ),
      body: subscribersAsync.when(
        data: (subscribers) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.people,
                      label: 'Suscriptores Activos',
                      value: '${subscribers.length}',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subscribers.length,
                itemBuilder: (context, index) {
                  final subscriber = subscribers[index];
                  return ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(subscriber.email),
                    subtitle: Text(
                      'Suscrito: ${DateFormat('dd/MM/yyyy').format(subscriber.subscribedAt)}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
