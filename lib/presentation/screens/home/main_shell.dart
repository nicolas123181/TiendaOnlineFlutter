import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/cart_provider.dart';
import '../../widgets/common/bottom_nav_bar.dart';

/// Shell principal con navegación bottom
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBarWithBadge(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        cartBadge: cartState.itemCount,
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/products') || location.startsWith('/product/')) {
      return 1;
    }
    if (location.startsWith('/wishlist')) {
      return 2;
    }
    if (location.startsWith('/cart')) {
      return 3;
    }
    if (location.startsWith('/profile') ||
        location.startsWith('/orders') ||
        location.startsWith('/addresses') ||
        location.startsWith('/settings')) {
      return 4;
    }

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/products');
        break;
      case 2:
        context.go('/wishlist');
        break;
      case 3:
        context.go('/cart');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
