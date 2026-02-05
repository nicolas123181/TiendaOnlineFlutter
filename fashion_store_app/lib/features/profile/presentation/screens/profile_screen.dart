import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Pantalla de perfil del usuario
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MI CUENTA'),
        actions: [
          userAsync.when(
            data: (user) {
              if (user != null) {
                return IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push('/settings'),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _NotLoggedInState();
          }
          return _ProfileContent(user: user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _NotLoggedInState(),
      ),
    );
  }
}

class _NotLoggedInState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 24),
            Text(
              'Inicia sesión para ver tu perfil',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Accede a tus pedidos, favoritos y más',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/auth/login'),
                child: const Text('INICIAR SESIÓN'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/auth/register'),
                child: const Text('CREAR CUENTA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final dynamic user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      key: const PageStorageKey<String>('profile-scroll'),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar y nombre
          CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primary,
            child: Text(
              user.initials ?? user.email[0].toUpperCase(),
              style: AppTextStyles.h2.copyWith(color: colorScheme.onPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Text(user.displayName ?? user.email, style: textTheme.headlineSmall),
          Text(
            user.email,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          // Opciones del menú
          _MenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Mis Pedidos',
            subtitle: 'Ver historial de compras',
            onTap: () => context.push('/orders'),
          ),
          _MenuItem(
            icon: Icons.favorite_outline,
            title: 'Favoritos',
            subtitle: 'Productos guardados',
            onTap: () => context.push('/favorites'),
          ),
          _MenuItem(
            icon: Icons.location_on_outlined,
            title: 'Direcciones',
            subtitle: 'Gestionar direcciones de envío',
            onTap: () => context.push('/addresses'),
          ),
          const SizedBox(height: 24),

          // Cerrar sesión
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await ref.read(authActionsProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/');
                }
              },
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('CERRAR SESIÓN'),
            ),
          ),
        ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: textTheme.labelLarge),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      onTap: onTap,
    );
  }
}
