// Pantallas de Admin Panel

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Dashboard del Admin Panel
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authActionsProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      drawer: const _AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: AppTextStyles.h2),
            const SizedBox(height: 24),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: const [
                _StatCard(
                  icon: Icons.shopping_bag,
                  label: 'Pedidos Hoy',
                  value: '12',
                  color: AppColors.info,
                ),
                _StatCard(
                  icon: Icons.euro,
                  label: 'Ventas Hoy',
                  value: '1,234 €',
                  color: AppColors.success,
                ),
                _StatCard(
                  icon: Icons.inventory,
                  label: 'Productos',
                  value: '156',
                  color: AppColors.primary,
                ),
                _StatCard(
                  icon: Icons.people,
                  label: 'Clientes',
                  value: '89',
                  color: AppColors.accent,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text('Acciones Rápidas', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.add,
                    label: 'Nuevo Producto',
                    onTap: () => context.go('/admin/products/new'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.list_alt,
                    label: 'Ver Pedidos',
                    onTap: () => context.go('/admin/orders'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Drawer del Admin Panel
class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VANTAGE',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Panel de Administración',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            _DrawerItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
                context.go('/admin');
              },
            ),
            _DrawerItem(
              icon: Icons.inventory_2,
              label: 'Productos',
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/products');
              },
            ),
            _DrawerItem(
              icon: Icons.shopping_bag,
              label: 'Pedidos',
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/orders');
              },
            ),
            _DrawerItem(
              icon: Icons.settings,
              label: 'Configuración',
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/settings');
              },
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.store,
              label: 'Ver Tienda',
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(label), onTap: onTap);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.h3),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}

/// Pantalla de productos del admin
class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/admin/products/new'),
          ),
        ],
      ),
      body: const Center(child: Text('Lista de productos - En desarrollo')),
    );
  }
}

/// Pantalla de pedidos del admin
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: const Center(child: Text('Lista de pedidos - En desarrollo')),
    );
  }
}

/// Pantalla de configuración del admin
class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Flash Offers Switch
          _SettingsTile(
            icon: Icons.bolt,
            title: 'Ofertas Flash',
            subtitle: 'Activar/desactivar ofertas en la tienda',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implementar toggle
              },
            ),
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.email,
            title: 'Newsletter',
            subtitle: 'Configurar suscripciones',
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.palette,
            title: 'Apariencia',
            subtitle: 'Temas y colores',
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.labelLarge),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: trailing,
    );
  }
}
