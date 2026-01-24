import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/app_colors.dart';

/// Campo de texto personalizado
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsets? contentPadding;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: widget.enabled
                ? AppColors.surfaceLight
                : AppColors.surfaceMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: AppColors.brandNavy,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo de búsqueda
class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final FocusNode? focusNode;

  const SearchTextField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint ?? 'Buscar...',
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 20,
        ),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.brandNavy,
            width: 1,
          ),
        ),
      ),
    );
  }
}

/// Campo de código (OTP)
class CodeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final int length;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  final FocusNode? focusNode;

  const CodeTextField({
    super.key,
    this.controller,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: length,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        onChanged?.call(value);
        if (value.length == length) {
          onCompleted?.call(value);
        }
      },
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 16,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(
            color: AppColors.brandNavy,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
