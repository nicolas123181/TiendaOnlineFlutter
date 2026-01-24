import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_colors.dart';

/// Indicador de carga circular
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.brandNavy,
        ),
      ),
    );
  }
}

/// Pantalla de carga completa
class LoadingScreen extends StatelessWidget {
  final String? message;

  const LoadingScreen({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Overlay de carga
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? barrierColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: barrierColor ?? Colors.black.withOpacity(0.3),
            child: LoadingScreen(message: message),
          ),
      ],
    );
  }
}

/// Shimmer para productos
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceMedium,
      highlightColor: AppColors.surfaceLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Nombre
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          // Precio
          Container(
            height: 14,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer para grid de productos
class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGridShimmer({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

/// Shimmer para lista
class ListItemShimmer extends StatelessWidget {
  final double height;

  const ListItemShimmer({
    super.key,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceMedium,
      highlightColor: AppColors.surfaceLight,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen
            Container(
              width: height - 24,
              height: height - 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer para categorías horizontales
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceMedium,
      highlightColor: AppColors.surfaceLight,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer para detalles de producto
class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceMedium,
      highlightColor: AppColors.surfaceLight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            AspectRatio(
              aspectRatio: 1,
              child: Container(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Container(
                    height: 24,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  // Precio
                  Container(
                    height: 20,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  // Tallas
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 48,
                          height: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Descripción
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 200,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
