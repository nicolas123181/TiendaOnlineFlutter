import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

/// Botón primario personalizado
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: isSmall ? 16 : 24,
          vertical: isSmall ? 12 : 16,
        );

    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.brandNavy,
            side: BorderSide(
              color: backgroundColor ?? AppColors.brandNavy,
              width: 1.5,
            ),
            padding: buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.brandNavy,
            foregroundColor: textColor ?? Colors.white,
            padding: buttonPadding,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          );

    final child = isLoading
        ? SizedBox(
            height: isSmall ? 16 : 20,
            width: isSmall ? 16 : 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppColors.brandNavy : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isSmall ? 16 : 20),
                const SizedBox(width: 8),
              ],
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: isSmall ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: child,
          );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}

/// Botón de icono circular
class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final bool hasShadow;
  final String? badge;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.iconSize = 20,
    this.hasShadow = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).cardColor,
            shape: BoxShape.circle,
            boxShadow: hasShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(size / 2),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.brandGold,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Botón de texto con subrayado
class UnderlinedTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double fontSize;

  const UnderlinedTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? AppColors.brandNavy,
          fontSize: fontSize,
          decoration: TextDecoration.underline,
          decorationColor: color ?? AppColors.brandNavy,
        ),
      ),
    );
  }
}

/// Botón con gradiente
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color>? colors;
  final double? width;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.colors,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? AppColors.primaryGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Text(
                    text.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Botón de favorito (corazón)
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;
  final double size;
  final bool isLoading;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    this.onPressed,
    this.size = 24,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isLoading
            ? SizedBox(
                width: size,
                height: size,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                color: isFavorite ? AppColors.error : AppColors.textSecondary,
                size: size,
              ),
      ),
    );
  }
}
