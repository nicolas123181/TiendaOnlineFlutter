import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/app_colors.dart';

/// AppBar personalizado de VANTAGE
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.centerTitle = true,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? AppColors.surfaceDark : Colors.white);

    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0.5,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      automaticallyImplyLeading: showBackButton,
      centerTitle: centerTitle,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              : null),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// AppBar con logo de VANTAGE
class VantageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double elevation;

  const VantageAppBar({
    super.key,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? AppColors.surfaceDark : Colors.white);

    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0.5,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      centerTitle: true,
      title: const VantageLogo(),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// Logo de VANTAGE
class VantageLogo extends StatelessWidget {
  final double height;
  final Color? color;

  const VantageLogo({
    super.key,
    this.height = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        color ?? (isDark ? Colors.white : AppColors.brandNavy);

    return Text(
      'VANTAGE',
      style: TextStyle(
        fontSize: height,
        fontWeight: FontWeight.bold,
        color: effectiveColor,
        letterSpacing: 4,
      ),
    );
  }
}

/// AppBar transparente para pantallas con imagen de fondo
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const TransparentAppBar({
    super.key,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: showBackButton
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      automaticallyImplyLeading: showBackButton,
      actions: actions?.map((action) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: action,
          ),
        );
      }).toList(),
    );
  }
}

/// AppBar para búsqueda
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onBackPressed;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    required this.controller,
    this.hintText = 'Buscar productos...',
    this.onBackPressed,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontSize: 16,
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
      actions: [
        if (controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 20,
            ),
            onPressed: () {
              controller.clear();
              onClear?.call();
            },
          ),
      ],
    );
  }
}

/// Tab bar personalizado
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController controller;
  final bool isScrollable;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.isScrollable = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      labelColor: AppColors.brandNavy,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.brandNavy,
          width: 2,
        ),
      ),
      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
    );
  }
}

/// Sliver AppBar para pantallas con scroll
class CustomSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? flexibleSpace;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.flexibleSpace,
    this.expandedHeight = 200,
    this.pinned = true,
    this.floating = false,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      elevation: 0,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      flexibleSpace: flexibleSpace,
      actions: actions,
      bottom: bottom,
    );
  }
}
