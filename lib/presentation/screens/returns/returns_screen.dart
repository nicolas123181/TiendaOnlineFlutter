import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';

/// Pantalla de lista de devoluciones
class ReturnsScreen extends ConsumerStatefulWidget {
  const ReturnsScreen({super.key});

  @override
  ConsumerState<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends ConsumerState<ReturnsScreen> {
  bool _isLoading = true;
  List<ReturnRequest> _returns = [];

  @override
  void initState() {
    super.initState();
    _loadReturns();
  }

  Future<void> _loadReturns() async {
    // Simular carga
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _returns = [
          ReturnRequest(
            id: 'RET001',
            orderId: 'ORD123',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
            status: 'pending',
            itemCount: 2,
            totalAmount: 8990,
          ),
          ReturnRequest(
            id: 'RET002',
            orderId: 'ORD456',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
            status: 'approved',
            itemCount: 1,
            totalAmount: 4500,
          ),
          ReturnRequest(
            id: 'RET003',
            orderId: 'ORD789',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            status: 'refunded',
            itemCount: 3,
            totalAmount: 15990,
          ),
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mis Devoluciones',
        showBackButton: true,
      ),
      body: _isLoading
          ? const LoadingScreen()
          : _returns.isEmpty
              ? _buildEmptyState()
              : _buildReturnsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_return_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sin devoluciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No tienes solicitudes de devolución',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.push('/orders'),
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Ver mis pedidos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnsList() {
    return RefreshIndicator(
      onRefresh: _loadReturns,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _returns.length,
        itemBuilder: (context, index) {
          final returnRequest = _returns[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ReturnCard(
              returnRequest: returnRequest,
              onTap: () => context.push('/returns/${returnRequest.id}'),
            ),
          );
        },
      ),
    );
  }
}

class _ReturnCard extends StatelessWidget {
  final ReturnRequest returnRequest;
  final VoidCallback onTap;

  const _ReturnCard({
    required this.returnRequest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devolución #${returnRequest.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pedido #${returnRequest.orderId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                ReturnStatusBadge(status: returnRequest.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${returnRequest.itemCount} ${returnRequest.itemCount == 1 ? 'artículo' : 'artículos'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '€${(returnRequest.totalAmount / 100).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(returnRequest.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onTap,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ver detalles'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

class ReturnRequest {
  final String id;
  final String orderId;
  final DateTime createdAt;
  final String status;
  final int itemCount;
  final int totalAmount;

  const ReturnRequest({
    required this.id,
    required this.orderId,
    required this.createdAt,
    required this.status,
    required this.itemCount,
    required this.totalAmount,
  });
}
