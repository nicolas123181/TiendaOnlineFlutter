import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/auth_provider.dart';

/// Pantalla splash de VANTAGE
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Esperar a que se complete la animación mínima
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final isAuthenticated = ref.read(isAuthenticatedProvider);
    final user = ref.read(currentUserProvider);

    if (isAuthenticated) {
      if (user?.role == 'admin') {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    } else {
      // No logueado - ir al home
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandNavy,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Text(
                      'VANTAGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tagline
                    const Text(
                      'FASHION',
                      style: TextStyle(
                        color: AppColors.brandGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 12,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Indicador de carga
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
