import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../data/models/return_model.dart';

/// Provider para obtener devolución por orden
final returnByOrderProvider = FutureProvider.family<ReturnRequest?, int>((
  ref,
  orderId,
) async {
  final supabase = ref.read(supabaseClientProvider);

  try {
    final response = await supabase
        .from('returns')
        .select('*, return_items(*)')
        .eq('order_id', orderId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return ReturnRequest.fromJson(response);
  } catch (e) {
    return null;
  }
});

/// Pantalla para crear solicitud de devolución
class CreateReturnScreen extends ConsumerStatefulWidget {
  final int orderId;

  const CreateReturnScreen({super.key, required this.orderId});

  @override
  ConsumerState<CreateReturnScreen> createState() => _CreateReturnScreenState();
}

class _CreateReturnScreenState extends ConsumerState<CreateReturnScreen> {
  String? _selectedReason;
  final _notesController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Devolución')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tienes 30 días desde la entrega para solicitar una devolución.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Razón de devolución
            Text('Motivo de la devolución *', style: AppTextStyles.labelLarge),
            const SizedBox(height: 12),
            ...ReturnReasons.all.map(
              (reason) => RadioListTile<String>(
                title: Text(reason, style: AppTextStyles.bodyMedium),
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) => setState(() => _selectedReason = value),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Notas adicionales
            Text(
              'Comentarios adicionales (opcional)',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe cualquier detalle adicional...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.backgroundSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Error message
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedReason != null && !_isLoading
                    ? _submitReturn
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Enviar Solicitud'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReturn() async {
    if (_selectedReason == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final supabase = ref.read(supabaseClientProvider);

      // Crear número de devolución
      final returnNumber =
          'RET-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      // Insertar devolución
      await supabase.from('returns').insert({
        'order_id': widget.orderId,
        'return_number': returnNumber,
        'status': 'pending',
        'reason': _selectedReason,
        'customer_notes': _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        'refund_amount': 0, // Se calculará en el backend
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud de devolución enviada correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Error al enviar la solicitud: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// Pantalla de detalle de devolución
class ReturnDetailScreen extends ConsumerWidget {
  final int returnId;

  const ReturnDetailScreen({super.key, required this.returnId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Crear provider para obtener devolución por ID
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Devolución')),
      body: const Center(child: Text('Detalle de devolución')),
    );
  }
}

/// Widget para mostrar estado de devolución
class ReturnStatusBadge extends StatelessWidget {
  final String status;

  const ReturnStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'pending':
        bgColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'approved':
        bgColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        break;
      case 'completed':
        bgColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'rejected':
      case 'cancelled':
        bgColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
      default:
        bgColor = AppColors.backgroundSecondary;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusLabel(status),
        style: AppTextStyles.labelSmall.copyWith(color: textColor),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'approved':
        return 'Aprobada';
      case 'completed':
        return 'Completada';
      case 'rejected':
        return 'Rechazada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }
}
