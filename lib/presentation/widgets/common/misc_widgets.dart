import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

/// Section header para listas
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsets padding;
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              if (actionText != null && onAction != null)
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionText!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brandNavy,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border,
          ),
      ],
    );
  }
}

/// Divider con texto
class DividerWithText extends StatelessWidget {
  final String text;
  final Color? color;

  const DividerWithText({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppColors.border;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Divider(color: dividerColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : const Color(0xFF4B5563),
            ),
          ),
        ),
        Expanded(
          child: Divider(color: dividerColor),
        ),
      ],
    );
  }
}

/// Stepper horizontal para checkout
class CheckoutStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Línea conectora
            final stepIndex = (index - 1) ~/ 2;
            final isCompleted = stepIndex < currentStep;

            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? AppColors.brandNavy : AppColors.border,
              ),
            );
          }

          // Paso
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isCurrent = stepIndex == currentStep;

          return Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? AppColors.brandNavy
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted || isCurrent
                        ? AppColors.brandNavy
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isCurrent ? AppColors.brandNavy : AppColors.textSecondary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Progress tracker vertical para tracking de pedido
class OrderProgressTracker extends StatelessWidget {
  final List<TrackingStep> steps;

  const OrderProgressTracker({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador y línea
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: step.isCompleted
                          ? AppColors.success
                          : step.isCurrent
                              ? AppColors.brandNavy
                              : AppColors.surfaceMedium,
                      shape: BoxShape.circle,
                    ),
                    child: step.isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          )
                        : step.isCurrent
                            ? Container(
                                margin: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: step.isCompleted
                            ? AppColors.success
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Contenido
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: step.isCurrent || step.isCompleted
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: step.isCurrent || step.isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (step.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          step.subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (step.date != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(step.date!),
                          style: TextStyle(
                            fontSize: 12,
                            color: step.isCompleted
                                ? AppColors.success
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}

class TrackingStep {
  final String title;
  final String? subtitle;
  final DateTime? date;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.title,
    this.subtitle,
    this.date,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

/// Rating stars
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showValue;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.brandGold;
    final inactive = inactiveColor ?? AppColors.textTertiary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star, size: size, color: active);
          } else if (index < rating) {
            return Icon(Icons.star_half, size: size, color: active);
          }
          return Icon(Icons.star_border, size: size, color: inactive);
        }),
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.875,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Switch con label
class LabeledSwitch extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const LabeledSwitch({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.brandNavy,
        ),
      ],
    );
  }
}

/// Expandable panel
class ExpandablePanel extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const ExpandablePanel({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: widget.child,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
