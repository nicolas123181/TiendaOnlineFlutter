import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/dialogs.dart';

/// Pantalla de perfil de usuario
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mi Cuenta',
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeader(profile: null, authUser: authUser),
              const Divider(height: 1),
              _buildContent(context, ref),
            ],
          ),
        ),
        data: (profile) => SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeader(profile: profile, authUser: authUser),
              const Divider(height: 1),
              _buildContent(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final isAdminAsync = ref.watch(isAdminProvider);

    return Column(
      children: [
        const SizedBox(height: 16),
        const _SectionTitle(title: 'MIS COMPRAS'),
        _MenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'Mis Pedidos',
          subtitle: 'Ver historial de pedidos',
          onTap: () => context.push('/orders'),
        ),
        _MenuItem(
          icon: Icons.favorite_outline,
          title: 'Lista de Deseos',
          subtitle: 'Productos guardados',
          onTap: () => context.push('/wishlist'),
        ),
        _MenuItem(
          icon: Icons.assignment_return_outlined,
          title: 'Devoluciones',
          subtitle: 'Gestionar devoluciones',
          onTap: () => context.push('/returns'),
        ),
        _MenuItem(
          icon: Icons.receipt_long_outlined,
          title: 'Facturas',
          subtitle: 'Descargar facturas',
          onTap: () => context.push('/invoices'),
        ),
        const SizedBox(height: 16),
        const _SectionTitle(title: 'MI CUENTA'),
        _MenuItem(
          icon: Icons.person_outline,
          title: 'Datos Personales',
          subtitle: 'Editar información personal',
          onTap: () => context.push('/profile/edit'),
        ),
        _MenuItem(
          icon: Icons.location_on_outlined,
          title: 'Direcciones',
          subtitle: 'Gestionar direcciones de envío',
          onTap: () => context.push('/addresses'),
        ),
        _MenuItem(
          icon: Icons.credit_card_outlined,
          title: 'Métodos de Pago',
          subtitle: 'Tarjetas guardadas',
          onTap: () => context.push('/payment-methods'),
        ),
        _MenuItem(
          icon: Icons.lock_outline,
          title: 'Cambiar Contraseña',
          subtitle: 'Actualizar contraseña',
          onTap: () => context.push('/change-password'),
        ),

        // Sección Admin - Solo visible para admins
        isAdminAsync.when(
          data: (isAdmin) {
            if (!isAdmin) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const _SectionTitle(title: '👑 ADMINISTRACIÓN'),
                _MenuItem(
                  icon: Icons.admin_panel_settings,
                  title: 'Panel de Administración',
                  subtitle: 'Gestionar tienda, productos y pedidos',
                  onTap: () => context.push('/admin'),
                ),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: 16),
        const _SectionTitle(title: 'AJUSTES'),
        _ThemeToggleItem(),
        _MenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notificaciones',
          subtitle: 'Configurar alertas',
          onTap: () => context.push('/notification-settings'),
        ),
        _MenuItem(
          icon: Icons.language_outlined,
          title: 'Idioma',
          subtitle: 'Español',
          onTap: () {
            // TODO: Selector de idioma
          },
        ),
        const SizedBox(height: 16),
        const _SectionTitle(title: 'SOPORTE'),
        _MenuItem(
          icon: Icons.help_outline,
          title: 'Centro de Ayuda',
          subtitle: 'Preguntas frecuentes',
          onTap: () {
            // TODO: Abrir centro de ayuda
          },
        ),
        _MenuItem(
          icon: Icons.chat_bubble_outline,
          title: 'Contactar Soporte',
          subtitle: 'Hablar con un agente',
          onTap: () {
            // TODO: Abrir chat de soporte
          },
        ),
        _MenuItem(
          icon: Icons.info_outline,
          title: 'Acerca de',
          subtitle: 'Versión 1.0.0',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'VANTAGE Fashion',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2024 VANTAGE Fashion',
            );
          },
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showLogoutDialog(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => _showDeleteAccountDialog(context, ref),
          child: const Text(
            'Eliminar mi cuenta',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await ConfirmDialog.show(
      context: context,
      title: 'Cerrar Sesión',
      message: '¿Estás seguro de que deseas cerrar sesión?',
      confirmText: 'Cerrar Sesión',
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirm = await ConfirmDialog.show(
      // Updated to use ConfirmDialog
      context: context,
      title: 'Eliminar Cuenta',
      message:
          'Esta acción es irreversible. Todos tus datos serán eliminados permanentemente.',
      confirmText: 'Eliminar Cuenta',
    );

    if (confirm == true) {
      // TODO: Implementar eliminación de cuenta
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud de eliminación enviada'),
          ),
        );
      }
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile? profile;
  final User? authUser;

  const _ProfileHeader({required this.profile, required this.authUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.brandNavy,
            backgroundImage: profile?.avatarUrl != null
                ? NetworkImage(profile!.avatarUrl!)
                : null,
            child: profile?.avatarUrl == null
                ? Text(
                    _getInitials(
                      profile?.name ??
                          authUser?.userMetadata?['full_name']?.toString() ??
                          authUser?.email ??
                          'U',
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ??
                      authUser?.userMetadata?['full_name']?.toString() ??
                      'Usuario',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.email ?? authUser?.email ?? 'email@example.com',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Editar
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surfaceLight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.brandNavy,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }
}

class _ThemeToggleItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(isDarkModeProvider); // Updated to use isDarkModeProvider

    return ListTile(
      leading: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: AppColors.brandNavy,
      ),
      title: const Text(
        'Modo Oscuro',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isDarkMode ? 'Activado' : 'Desactivado',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          ref.read(themeProvider.notifier).toggleTheme();
        },
        activeColor: AppColors.brandNavy,
      ),
    );
  }
}
