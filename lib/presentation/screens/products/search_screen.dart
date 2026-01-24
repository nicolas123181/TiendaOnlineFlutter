import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/product_card.dart';

/// Pantalla de búsqueda
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSearched = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _hasSearched = true;
      _currentQuery = query.trim();
    });
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _currentQuery = '';
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchState =
        _hasSearched ? ref.watch(searchResultsProvider(_currentQuery)) : null;
    final recentSearchesAsync = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: SearchAppBar(
        controller: _searchController,
        hintText: 'Buscar productos...',
        autofocus: true,
        onChanged: (value) {
          if (value.isEmpty && _hasSearched) {
            setState(() => _hasSearched = false);
          }
        },
        onSubmitted: _search,
        onClear: _clearSearch,
      ),
      body: _hasSearched && searchState != null
          ? _buildSearchResults(searchState)
          : recentSearchesAsync.when(
              loading: () => const LoadingScreen(),
              error: (_, __) => _buildSearchSuggestions(const []),
              data: (recentSearches) => _buildSearchSuggestions(recentSearches),
            ),
    );
  }

  Widget _buildSearchSuggestions(List<String> recentSearches) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Búsquedas recientes
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'BÚSQUEDAS RECIENTES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(productRepositoryProvider).clearRecentSearches();
                    ref.invalidate(recentSearchesProvider);
                  },
                  child: const Text(
                    'Borrar',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return _SearchChip(
                  text: search,
                  onTap: () {
                    _searchController.text = search;
                    _search(search);
                  },
                  onRemove: () {
                    ref
                        .read(productRepositoryProvider)
                        .removeRecentSearch(search);
                    ref.invalidate(recentSearchesProvider);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],

          // Búsquedas populares
          const Text(
            'BÚSQUEDAS POPULARES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Trajes',
              'Camisas',
              'Pantalones',
              'Blazer',
              'Corbatas',
              'Zapatos',
              'Cinturones',
              'Chaquetas',
            ].map((search) {
              return _SuggestionChip(
                text: search,
                onTap: () {
                  _searchController.text = search;
                  _search(search);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Categorías
          const Text(
            'EXPLORAR CATEGORÍAS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _CategoryList(),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<Product>> state) {
    return state.when(
      loading: () => const ProductGridShimmer(),
      error: (_, __) => _buildNoResults(),
      data: (products) {
        if (products.isEmpty) {
          return _buildNoResults();
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.push('/product/${product.id}'),
            );
          },
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 24),
            const Text(
              'No se encontraron resultados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No encontramos productos para "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sugerencias:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Revisa la ortografía\n• Usa términos más generales\n• Prueba con palabras similares',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SearchChip({
    required this.text,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 4),
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.textSecondary,
              ),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Trajes', Icons.checkroom),
      ('Camisas', Icons.dry_cleaning),
      ('Pantalones', Icons.accessibility_new),
      ('Calzado', Icons.do_not_step),
      ('Accesorios', Icons.watch),
      ('Abrigos', Icons.cloud),
    ];

    return Column(
      children: categories.map((category) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.brandNavy.withOpacity(0.1),
            ),
            child: Icon(
              category.$2,
              color: AppColors.brandNavy,
            ),
          ),
          title: Text(
            category.$1,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
          onTap: () =>
              context.push('/products?category=${category.$1.toLowerCase()}'),
        );
      }).toList(),
    );
  }
}
