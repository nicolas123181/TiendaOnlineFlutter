import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/empty_states.dart';

/// Pantalla de favoritos (placeholder)
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAVORITOS')),
      body: const EmptyState(
        icon: Icons.favorite_outline,
        title: 'Sin favoritos',
        subtitle: 'Los productos que marques como favoritos aparecerán aquí.',
      ),
    );
  }
}
