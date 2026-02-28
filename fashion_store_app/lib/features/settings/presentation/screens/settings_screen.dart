import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Pantalla de configuración de usuario
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userAsync = ref.watch(currentUserProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CONFIGURACIÓN')),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 80,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Inicia sesión para acceder a la configuración',
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.push('/auth/login'),
                      child: const Text('INICIAR SESIÓN'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del usuario
                Container(
                  padding: const EdgeInsets.all(24),
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          user.initials,
                          style: AppTextStyles.h3.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            if (isAdmin) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ADMINISTRADOR',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Sección de Admin (solo visible para admins)
                if (isAdmin) ...[
                  const SizedBox(height: 8),
                  _SettingsSection(
                    title: 'ADMINISTRACIÓN',
                    icon: Icons.admin_panel_settings,
                    children: [
                      _SettingsTile(
                        icon: Icons.dashboard_outlined,
                        title: 'Panel de Administración',
                        subtitle:
                            'Gestionar productos, pedidos y configuración',
                        onTap: () => context.push('/admin'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ],

                // Sección de cuenta
                const SizedBox(height: 8),
                _SettingsSection(
                  title: 'MI CUENTA',
                  icon: Icons.person_outline,
                  children: [
                    _SettingsTile(
                      icon: Icons.edit_outlined,
                      title: 'Editar Perfil',
                      subtitle: 'Cambiar nombre, email y teléfono',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edición de perfil próximamente'),
                          ),
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Cambiar Contraseña',
                      subtitle: 'Actualizar tu contraseña',
                      onTap: () => context.push('/change-password'),
                    ),
                    _SettingsTile(
                      icon: Icons.location_on_outlined,
                      title: 'Direcciones de Envío',
                      subtitle: 'Gestionar tus direcciones guardadas',
                      onTap: () => context.push('/addresses'),
                    ),
                  ],
                ),

                // Sección de pedidos
                const SizedBox(height: 8),
                _SettingsSection(
                  title: 'PEDIDOS Y COMPRAS',
                  icon: Icons.shopping_bag_outlined,
                  children: [
                    _SettingsTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'Mis Pedidos',
                      subtitle: 'Ver historial de compras',
                      onTap: () => context.push('/orders'),
                    ),
                    _SettingsTile(
                      icon: Icons.favorite_outline,
                      title: 'Favoritos',
                      subtitle: 'Productos que me gustan',
                      onTap: () => context.go('/favorites'),
                    ),
                  ],
                ),

                // Sección de notificaciones
                const SizedBox(height: 8),
                _SettingsSection(
                  title: 'NOTIFICACIONES',
                  icon: Icons.notifications_outlined,
                  children: [
                    _SettingsTile(
                      icon: Icons.email_outlined,
                      title: 'Alertas por Email',
                      subtitle: 'Ofertas y stock bajo en favoritos',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Notificaciones activadas'
                                    : 'Notificaciones desactivadas',
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: null,
                    ),
                    _SettingsTile(
                      icon: Icons.local_offer_outlined,
                      title: 'Newsletter',
                      subtitle: 'Recibir novedades y promociones',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Newsletter activado'
                                    : 'Newsletter desactivado',
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: null,
                    ),
                  ],
                ),

                // Sección de información
                const SizedBox(height: 8),
                _SettingsSection(
                  title: 'INFORMACIÓN',
                  icon: Icons.info_outline,
                  children: [
                    _SettingsTile(
                      icon: Icons.straighten,
                      title: 'Recomendador de Tallas',
                      subtitle: 'Encuentra tu talla perfecta',
                      onTap: () => context.push('/size-recommender'),
                    ),
                    _SettingsTile(
                      icon: Icons.store_outlined,
                      title: 'Sobre Nosotros',
                      subtitle: 'Conoce nuestra historia y valores',
                      onTap: () => context.push('/about'),
                    ),
                    _SettingsTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'Envíos y Devoluciones',
                      subtitle: 'Políticas de envío y devoluciones',
                      onTap: () => context.push('/shipping-returns'),
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Política de Privacidad',
                      subtitle: 'Cómo tratamos tus datos',
                      onTap: () => context.push('/privacy'),
                    ),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Términos y Condiciones',
                      subtitle: 'Condiciones de uso del servicio',
                      onTap: () => context.push('/terms'),
                    ),
                    _SettingsTile(
                      icon: Icons.info,
                      title: 'Acerca de VANTAGE',
                      subtitle: 'Versión 1.0.0',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'VANTAGE',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© 2026 VANTAGE Fashion',
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Moda Masculina Premium\n\nTu destino para las últimas tendencias en moda masculina.',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                // Botón de cerrar sesión
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cerrar Sesión'),
                            content: const Text(
                              '¿Estás seguro de que quieres cerrar sesión?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('CANCELAR'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                                child: const Text('CERRAR SESIÓN'),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true && context.mounted) {
                          await ref
                              .read(authActionsProvider.notifier)
                              .signOut();
                          if (context.mounted) {
                            context.go('/');
                          }
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('CERRAR SESIÓN'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error al cargar configuración',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget de sección de configuración
class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// Widget de opción de configuración
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 24),
      ),
      title: Text(title, style: textTheme.labelLarge),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
      onTap: onTap,
    );
  }
}
