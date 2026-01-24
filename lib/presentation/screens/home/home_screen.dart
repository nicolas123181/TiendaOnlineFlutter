import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/flash_offers_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/image_carousel.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/misc_widgets.dart';
import '../../widgets/common/product_card.dart';

/// Pantalla principal de la app
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final flashOffersAsync = ref.watch(flashOffersEnabledProvider);

    return Scaffold(
      appBar: VantageAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => context.push('/cart'),
              ),
              if (cartState.itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CounterBadge(count: cartState.itemCount),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(featuredProductsProvider.future),
            ref.refresh(newProductsProvider.future),
            ref.refresh(saleProductsProvider.future),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            // Hero Banner
            SliverToBoxAdapter(
              child: HeroBanner(
                imageUrl:
                    'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=800',
                title: 'Nueva Colección\nOtoño/Invierno',
                subtitle: 'Exclusivo',
                buttonText: 'Descubrir',
                onTap: () => context.push('/products?collection=aw24'),
              ),
            ),

            // Categorías
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    const SectionHeader(
                      title: 'Comprar por Categoría',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _CategoryItem(
                            title: 'Trajes',
                            icon: Icons.checkroom,
                            onTap: () =>
                                context.push('/products?category=trajes'),
                          ),
                          _CategoryItem(
                            title: 'Camisas',
                            icon: Icons.dry_cleaning,
                            onTap: () =>
                                context.push('/products?category=camisas'),
                          ),
                          _CategoryItem(
                            title: 'Pantalones',
                            icon: Icons.accessibility_new,
                            onTap: () =>
                                context.push('/products?category=pantalones'),
                          ),
                          _CategoryItem(
                            title: 'Calzado',
                            icon: Icons.do_not_step,
                            onTap: () =>
                                context.push('/products?category=calzado'),
                          ),
                          _CategoryItem(
                            title: 'Accesorios',
                            icon: Icons.watch,
                            onTap: () =>
                                context.push('/products?category=accesorios'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Productos Destacados
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    SectionHeader(
                      title: 'Destacados',
                      actionText: 'Ver todo',
                      onAction: () => context.push('/products?featured=true'),
                    ),
                    const SizedBox(height: 16),
                    _ProductsHorizontalList(
                      provider: featuredProductsProvider,
                    ),
                  ],
                ),
              ),
            ),

            // Banner Promocional
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: PromoBanner(
                  imageUrl:
                      'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800',
                  title: '-20% EN TRAJES',
                  subtitle: 'OFERTA ESPECIAL',
                  buttonText: 'COMPRAR',
                  height: 180,
                  onTap: () =>
                      context.push('/products?category=trajes&sale=true'),
                ),
              ),
            ),

            // Nuevas Llegadas
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SectionHeader(
                    title: 'Nuevas Llegadas',
                    actionText: 'Ver todo',
                    onAction: () => context.push('/products?new=true'),
                  ),
                  const SizedBox(height: 16),
                  _ProductsHorizontalList(
                    provider: newProductsProvider,
                  ),
                ],
              ),
            ),

            // Servicios
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    const SectionHeader(title: 'Servicios VANTAGE'),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ServiceCard(
                              icon: Icons.local_shipping_outlined,
                              title: 'Envío Gratis',
                              subtitle: 'En pedidos +€150',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ServiceCard(
                              icon: Icons.refresh,
                              title: 'Devolución',
                              subtitle: '30 días gratis',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ServiceCard(
                              icon: Icons.verified_outlined,
                              title: '100% Original',
                              subtitle: 'Garantizado',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ofertas Flash - Se muestran solo si el admin las tiene activadas (real-time)
            flashOffersAsync.when(
              data: (isEnabled) => isEnabled
                  ? SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SectionHeader(
                            title: '⚡ Ofertas Flash',
                            actionText: 'Ver todo',
                            onAction: () => context.push('/products?sale=true'),
                          ),
                          const SizedBox(height: 16),
                          _ProductsHorizontalList(
                            provider: saleProductsProvider,
                          ),
                        ],
                      ),
                    )
                  : const SliverToBoxAdapter(child: SizedBox.shrink()),
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator())),
              ),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // Newsletter
            SliverToBoxAdapter(
              child: _NewsletterSection(),
            ),

            // Espacio final
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _CategoryItem({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.brandNavy.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.brandNavy,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsHorizontalList extends ConsumerWidget {
  final ProviderListenable<AsyncValue<List<Product>>> provider;

  const _ProductsHorizontalList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(provider);

    return productsAsync.when(
      loading: () => SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 4,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 160,
                child: ProductCardShimmer(),
              ),
            );
          },
        ),
      ),
      error: (_, __) => const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No hay productos disponibles',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No hay productos disponibles',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 160,
                  child: ProductCard(
                    product: product,
                    onTap: () => context.push('/product/${product.id}'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.brandNavy,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NewsletterSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends ConsumerState<_NewsletterSection> {
  final _emailController = TextEditingController();
  bool _isSubscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _subscribe() {
    if (_emailController.text.isEmpty) return;

    // TODO: Implementar suscripción a newsletter
    setState(() => _isSubscribed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.brandNavy,
      ),
      child: _isSubscribed
          ? Column(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.brandGold,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Gracias por suscribirte!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Recibirás nuestras ofertas exclusivas.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Column(
              children: [
                const Text(
                  'ÚNETE A VANTAGE',
                  style: TextStyle(
                    color: AppColors.brandGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Recibe ofertas exclusivas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Suscríbete a nuestra newsletter y obtén un 10% de descuento en tu primera compra.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Tu email',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) => _subscribe(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _subscribe,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.brandGold,
                        ),
                        child: const Center(
                          child: Text(
                            'SUSCRIBIR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
