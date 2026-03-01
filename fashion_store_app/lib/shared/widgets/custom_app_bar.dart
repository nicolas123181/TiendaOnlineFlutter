import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/theme_provider.dart';

/// AppBar personalizado con acciones comunes (búsqueda, carrito, modo oscuro)
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final bool showSearch;
  final bool showCart;
  final bool showThemeToggle;
  final bool centerTitle;
  final Widget? leading;
  final VoidCallback? onSearchPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.additionalActions,
    this.showSearch = true,
    this.showCart = true,
    this.showThemeToggle = true,
    this.centerTitle = true,
    this.leading,
    this.onSearchPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final canUseThemeAsLeading =
        showThemeToggle && leading == null && !Navigator.of(context).canPop();

    final themeToggleButton = IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
      tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
    );

    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      leadingWidth: kToolbarHeight,
      actionsPadding: const EdgeInsets.only(right: 4),
      leading: canUseThemeAsLeading ? themeToggleButton : leading,
      actions: [
        // Botón de modo oscuro
        if (showThemeToggle && !canUseThemeAsLeading) themeToggleButton,

        // Botón de búsqueda
        if (showSearch)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed:
                onSearchPressed ??
                () {
                  // Abrir pantalla de búsqueda o mostrar bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _SearchBottomSheet(),
                  );
                },
          ),

        // Botón de carrito
        if (showCart)
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => context.push('/cart'),
          ),

        // Acciones adicionales
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }
}

/// Bottom sheet de búsqueda
class _SearchBottomSheet extends StatefulWidget {
  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pop(context);
                  context.push('/products?search=$value');
                }
              },
            ),
          ),

          // Resultados
          Expanded(
            child: _controller.text.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Escribe para buscar',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Buscar "${_controller.text}"',
                        style: const TextStyle(fontSize: 16),
                      ),
                      ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(_controller.text),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/products?search=${_controller.text}');
                        },
                      ),
                      // Aquí podrían ir sugerencias de búsqueda
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
