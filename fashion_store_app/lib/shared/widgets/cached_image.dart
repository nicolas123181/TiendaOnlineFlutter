import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme/app_colors.dart';
import 'loaders.dart';

/// Imagen de red con cache y placeholder
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    String resolvedUrl = imageUrl.trim();
    if (resolvedUrl.isNotEmpty &&
        (resolvedUrl.startsWith('http://') ||
            resolvedUrl.startsWith('https://'))) {
      // Encode URLs with spaces or unsafe characters (common in Windows).
      final needsEncoding = RegExp(r"[\s\[\]{}|\\^`]").hasMatch(
        resolvedUrl,
      );
      if (needsEncoding) {
        resolvedUrl = Uri.encodeFull(resolvedUrl);
      }
    }

    Widget image = CachedNetworkImage(
      imageUrl: resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            color: AppColors.shimmerBase,
            child: const Center(child: CustomLoader(size: 24)),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            color: AppColors.backgroundSecondary,
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
                size: 32,
              ),
            ),
          ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

/// Imagen de producto con Hero animation
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  final double? aspectRatio;
  final VoidCallback? onTap;
  final Widget? badge;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.aspectRatio = 3 / 4,
    this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = AspectRatio(
      aspectRatio: aspectRatio ?? 3 / 4,
      child: CachedImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    if (badge != null) {
      image = Stack(
        children: [
          image,
          Positioned(top: 8, left: 8, child: badge!),
        ],
      );
    }

    if (onTap != null) {
      image = GestureDetector(onTap: onTap, child: image);
    }

    return image;
  }
}

/// Galería de imágenes con miniaturas
class ImageGallery extends StatefulWidget {
  final List<String> images;
  final String? heroTagPrefix;
  final void Function(int index)? onImageTap;

  const ImageGallery({
    super.key,
    required this.images,
    this.heroTagPrefix,
    this.onImageTap,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          color: AppColors.backgroundSecondary,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.textSecondary,
              size: 48,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final showExtras = widget.images.length > 1;
        final indicatorsHeight = showExtras ? 20.0 : 0.0;
        final thumbnailsHeight = showExtras ? 72.0 : 0.0;
        final spacing = showExtras ? 24.0 : 0.0;
        final reserved = indicatorsHeight + thumbnailsHeight + spacing;
        final available = maxHeight.isFinite && maxHeight > reserved
            ? maxHeight - reserved
            : null;

        final showThumbnails = showExtras && (available == null || available > 240);

        return Column(
          children: [
            // Imagen principal con PageView
            if (available != null)
              SizedBox(
                height: available,
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                        },
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          final heroTag = widget.heroTagPrefix != null
                              ? '${widget.heroTagPrefix}_$index'
                              : null;
                          return GestureDetector(
                            onTap: () => widget.onImageTap?.call(index),
                            child: heroTag != null
                                ? Hero(
                                    tag: heroTag,
                                    child: CachedImage(
                                      imageUrl: widget.images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CachedImage(
                                    imageUrl: widget.images[index],
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),
                    ),
                    if (widget.images.length > 1) ...[
                      Positioned(
                        left: 12,
                        top: 0,
                        bottom: 0,
                        child: _GalleryNavButton(
                          icon: Icons.chevron_left,
                          onPressed: () {
                            final previous =
                                (_selectedIndex - 1 + widget.images.length) %
                                widget.images.length;
                            _pageController.animateToPage(
                              previous,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: _GalleryNavButton(
                          icon: Icons.chevron_right,
                          onPressed: () {
                            final next =
                                (_selectedIndex + 1) % widget.images.length;
                            _pageController.animateToPage(
                              next,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                        },
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          final heroTag = widget.heroTagPrefix != null
                              ? '${widget.heroTagPrefix}_$index'
                              : null;
                          return GestureDetector(
                            onTap: () => widget.onImageTap?.call(index),
                            child: heroTag != null
                                ? Hero(
                                    tag: heroTag,
                                    child: CachedImage(
                                      imageUrl: widget.images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CachedImage(
                                    imageUrl: widget.images[index],
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),
                    ),
                    if (widget.images.length > 1) ...[
                      Positioned(
                        left: 12,
                        top: 0,
                        bottom: 0,
                        child: _GalleryNavButton(
                          icon: Icons.chevron_left,
                          onPressed: () {
                            final previous =
                                (_selectedIndex - 1 + widget.images.length) %
                                widget.images.length;
                            _pageController.animateToPage(
                              previous,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: _GalleryNavButton(
                          icon: Icons.chevron_right,
                          onPressed: () {
                            final next =
                                (_selectedIndex + 1) % widget.images.length;
                            _pageController.animateToPage(
                              next,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Indicadores de página
            if (showExtras) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _selectedIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],

            // Miniaturas
            if (showThumbnails) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedIndex == index
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedImage(
                            imageUrl: widget.images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _GalleryNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _GalleryNavButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.7),
        shape: const CircleBorder(),
        child: IconButton(
          icon: Icon(icon, size: 24, color: AppColors.primary),
          onPressed: onPressed,
          splashRadius: 22,
          tooltip: 'Cambiar imagen',
        ),
      ),
    );
  }
}
