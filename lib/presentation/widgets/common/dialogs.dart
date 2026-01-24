import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

/// Diálogo de confirmación genérico
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmColor;
  final bool isDanger;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.confirmColor,
    this.isDanger = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        isDanger: isDanger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText ?? 'Cancelar',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmText ?? 'Confirmar',
            style: TextStyle(
              color: confirmColor ??
                  (isDanger ? AppColors.error : AppColors.brandNavy),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Diálogo de eliminación
class DeleteDialog extends StatelessWidget {
  final String itemName;
  final String? message;

  const DeleteDialog({
    super.key,
    required this.itemName,
    this.message,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String itemName,
    String? message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteDialog(
        itemName: itemName,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      title: const Text(
        'Eliminar',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message ??
            '¿Estás seguro de que deseas eliminar "$itemName"? Esta acción no se puede deshacer.',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Eliminar',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Diálogo de éxito
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => SuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.success,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              buttonText ?? 'Aceptar',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet genérico
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;
  final bool showHandle;
  final bool showCloseButton;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.showHandle = true,
    this.showCloseButton = false,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    double? height,
    bool showHandle = true,
    bool showCloseButton = false,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => AppBottomSheet(
        title: title,
        height: height,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null || showCloseButton)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// Bottom sheet de opciones
class OptionsBottomSheet extends StatelessWidget {
  final String? title;
  final List<OptionItem> options;

  const OptionsBottomSheet({
    super.key,
    this.title,
    required this.options,
  });

  static Future<String?> show({
    required BuildContext context,
    String? title,
    required List<OptionItem> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => OptionsBottomSheet(
        title: title,
        options: options,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ...options.map((option) => ListTile(
                leading: option.icon != null
                    ? Icon(
                        option.icon,
                        color: option.isDanger
                            ? AppColors.error
                            : AppColors.textSecondary,
                      )
                    : null,
                title: Text(
                  option.label,
                  style: TextStyle(
                    color: option.isDanger
                        ? AppColors.error
                        : AppColors.textPrimary,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(option.value),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class OptionItem {
  final String label;
  final String value;
  final IconData? icon;
  final bool isDanger;

  const OptionItem({
    required this.label,
    required this.value,
    this.icon,
    this.isDanger = false,
  });
}

/// Bottom sheet de filtros
class FilterBottomSheet extends StatefulWidget {
  final String title;
  final List<FilterSection> sections;
  final VoidCallback? onReset;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.sections,
    this.onReset,
  });

  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required String title,
    required List<FilterSection> sections,
    VoidCallback? onReset,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => FilterBottomSheet(
        title: title,
        sections: sections,
        onReset: onReset,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = {};
    for (var section in widget.sections) {
      _selectedFilters[section.key] = section.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (var section in widget.sections) {
                          _selectedFilters[section.key] = null;
                        }
                      });
                      widget.onReset?.call();
                    },
                    child: const Text(
                      'Restablecer',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.sections.length,
                itemBuilder: (context, index) {
                  final section = widget.sections[index];
                  return ExpansionTile(
                    title: Text(
                      section.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    initiallyExpanded: index == 0,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: section.builder(
                          context,
                          _selectedFilters[section.key],
                          (value) {
                            setState(() {
                              _selectedFilters[section.key] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_selectedFilters),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandNavy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Aplicar filtros',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FilterSection {
  final String key;
  final String title;
  final dynamic initialValue;
  final Widget Function(
    BuildContext context,
    dynamic currentValue,
    ValueChanged<dynamic> onChanged,
  ) builder;

  const FilterSection({
    required this.key,
    required this.title,
    this.initialValue,
    required this.builder,
  });
}
