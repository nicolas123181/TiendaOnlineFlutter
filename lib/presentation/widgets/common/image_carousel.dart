import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/app_colors.dart';

/// Carrusel de imágenes para detalle de producto
class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double aspectRatio;
  final bool showThumbnails;
  final bool enableZoom;

  const ImageCarousel({
    super.key,
    required this.images,
    this.aspectRatio = 3 / 4,
    this.showThumbnails = true,
    this.enableZoom = true,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: AppColors.surfaceLight,
          child: const Center(
            child: Icon(
              Icons.image_outlined,
              size: 60,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      );
    }

    if (!widget.showThumbnails) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: widget.enableZoom
                      ? () => _showZoomDialog(context, index)
                      : null,
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceMedium,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceMedium,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.images.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PageIndicators(
                count: widget.images.length,
                currentIndex: _currentIndex,
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: widget.enableZoom
                    ? () => _showZoomDialog(context, index)
                    : null,
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surfaceMedium,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surfaceMedium,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 60,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.images.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == _currentIndex;
                  return GestureDetector(
                    onTap: () => _goToPage(index),
                    child: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.brandNavy
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  void _showZoomDialog(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageZoomGallery(
          images: widget.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

/// Indicadores de página
class _PageIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicators({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isSelected ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brandNavy : AppColors.textTertiary,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Galería de imágenes con zoom
class ImageZoomGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageZoomGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImageZoomGallery> createState() => _ImageZoomGalleryState();
}

class _ImageZoomGalleryState extends State<ImageZoomGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: Colors.white,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                  color: Colors.white54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Banner promocional con imagen
class PromoBanner extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onTap;
  final double height;

  const PromoBanner({
    super.key,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onTap,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceMedium,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceMedium,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            // Overlay gradiente
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppColors.brandGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  if (title != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                  if (buttonText != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        buttonText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hero banner para home
class HeroBanner extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onTap;

  const HeroBanner({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: screenHeight * 0.6,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.brandNavy,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.brandNavy,
              ),
            ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Contenido
            Positioned(
              left: 24,
              right: 24,
              bottom: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitle != null)
                    Text(
                      subtitle!.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.brandGold,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  if (buttonText != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        buttonText!.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.brandNavy,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
