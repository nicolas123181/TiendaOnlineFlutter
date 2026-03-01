// Pantallas completas y funcionales del Admin Panel
// Incluye: Facturas, Devoluciones, Newsletter, Configuración, Alertas de Stock

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/constants/app_constants.dart';
import '../../data/models/invoice.dart';
import '../../data/models/return_model.dart';
import '../providers/invoices_provider.dart';
import '../providers/returns_provider.dart';
import '../providers/newsletter_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/sizes_provider.dart';

// ==========================================
// PANTALLA DE FACTURAS MEJORADA
// ==========================================

class AdminInvoicesScreenComplete extends ConsumerStatefulWidget {
  const AdminInvoicesScreenComplete({super.key});

  @override
  ConsumerState<AdminInvoicesScreenComplete> createState() =>
      _AdminInvoicesScreenCompleteState();
}

class _AdminInvoicesScreenCompleteState
    extends ConsumerState<AdminInvoicesScreenComplete> {
  String _searchQuery = '';
  // 'all' | 'rectificativa' | 'pagada'
  String _typeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Facturas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(invoicesProvider),
          ),
        ],
      ),
      body: invoicesAsync.when(
        data: (allInvoices) {
          // Stats
          final totalBilled = allInvoices.fold<double>(
            0,
            (s, inv) => s + inv.total,
          );
          final sentCount = allInvoices
              .where((inv) => inv.status == 'sent')
              .length;
          final pendingCount = allInvoices
              .where((inv) => inv.status == 'pending')
              .length;

          // Filter
          final filtered = allInvoices.where((inv) {
            final q = _searchQuery.toLowerCase();
            final matchesSearch =
                q.isEmpty ||
                inv.invoiceNumber.toLowerCase().contains(q) ||
                inv.customerName.toLowerCase().contains(q) ||
                inv.customerEmail.toLowerCase().contains(q) ||
                inv.orderId.toString().contains(q);
            final matchesType =
                _typeFilter == 'all' ||
                (_typeFilter == 'rectificativa' && inv.total < 0) ||
                (_typeFilter == 'pagada' && inv.total >= 0);
            return matchesSearch && matchesType;
          }).toList();

          return Column(
            children: [
              // Stats header
              Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    _StatChip(
                      label: 'Total',
                      value: '${allInvoices.length}',
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: 'Facturado',
                      value: '${totalBilled.toStringAsFixed(0)}€',
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: 'Enviadas',
                      value: '$sentCount',
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: 'Pendientes',
                      value: '$pendingCount',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nº factura, cliente, email…',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              // Type filter chips
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Rectificativa'),
                      selected: _typeFilter == 'rectificativa',
                      showCheckmark: false,
                      avatar: Icon(
                        Icons.receipt_long,
                        size: 16,
                        color: _typeFilter == 'rectificativa'
                            ? Colors.red[700]
                            : Colors.grey[500],
                      ),
                      selectedColor: Colors.red.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: _typeFilter == 'rectificativa'
                            ? Colors.red[700]
                            : null,
                        fontWeight: _typeFilter == 'rectificativa'
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      onSelected: (on) => setState(
                        () => _typeFilter = on ? 'rectificativa' : 'all',
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Pagada'),
                      selected: _typeFilter == 'pagada',
                      showCheckmark: false,
                      avatar: Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: _typeFilter == 'pagada'
                            ? Colors.green[700]
                            : Colors.grey[500],
                      ),
                      selectedColor: Colors.green.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: _typeFilter == 'pagada'
                            ? Colors.green[700]
                            : null,
                        fontWeight: _typeFilter == 'pagada'
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      onSelected: (on) =>
                          setState(() => _typeFilter = on ? 'pagada' : 'all'),
                    ),
                    if (_typeFilter != 'all') ...[
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => setState(() => _typeFilter = 'all'),
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: 'Limpiar filtro',
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1),
              // Invoice list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty || _typeFilter != 'all'
                                  ? 'Sin resultados para la búsqueda'
                                  : 'No hay facturas generadas',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _InvoiceCardComplete(invoice: filtered[index]);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(invoicesProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small stats chip for invoices header
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceCardComplete extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceCardComplete({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showInvoiceDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          invoice.customerName,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: invoice.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${invoice.orderId.toString().padLeft(5, '0')}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(invoice.issueDate),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${invoice.total.toStringAsFixed(2)} €',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvoiceDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Factura ${invoice.invoiceNumber}',
                      style: AppTextStyles.h3,
                    ),
                  ),
                  IconButton(
                    tooltip: invoice.pdfUrl != null
                        ? 'Descargar PDF'
                        : 'Abrir factura',
                    icon: Icon(
                      Icons.download,
                      color: invoice.pdfUrl != null
                          ? Colors.red[400]
                          : Colors.blue,
                    ),
                    onPressed: () async {
                      final url =
                          invoice.pdfUrl ??
                          '${AppConstants.webApiBaseUrl}/api/invoice/${invoice.id}/pdf?download=true';
                      final uri = Uri.parse(url);
                      try {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (_) {
                        // Fallback: intentar modo por defecto del sistema
                        try {
                          await launchUrl(uri);
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No se pudo abrir: $url')),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Datos empresa
              _DetailSection(
                title: 'Datos de la Empresa',
                children: [
                  _DetailRow('Empresa', invoice.companyName),
                  if (invoice.companyAddress != null)
                    _DetailRow('Dirección', invoice.companyAddress!),
                  if (invoice.companyNif != null)
                    _DetailRow('NIF', invoice.companyNif!),
                  if (invoice.companyEmail != null)
                    _DetailRow('Email', invoice.companyEmail!),
                ],
              ),
              const SizedBox(height: 16),

              // Datos cliente
              _DetailSection(
                title: 'Datos del Cliente',
                children: [
                  _DetailRow('Nombre', invoice.customerName),
                  _DetailRow('Email', invoice.customerEmail),
                  if (invoice.customerPhone != null)
                    _DetailRow('Teléfono', invoice.customerPhone!),
                  if (invoice.customerAddress != null)
                    _DetailRow('Dirección', invoice.customerAddress!),
                  if (invoice.customerCity != null)
                    _DetailRow(
                      'Ciudad',
                      '${invoice.customerPostalCode ?? ''} ${invoice.customerCity!}',
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Desglose
              _DetailSection(
                title: 'Desglose',
                children: [
                  _DetailRow(
                    'Subtotal',
                    '${invoice.subtotal.toStringAsFixed(2)} €',
                  ),
                  if (invoice.discount > 0)
                    _DetailRow(
                      'Descuento',
                      '-${invoice.discount.toStringAsFixed(2)} €',
                    ),
                  _DetailRow(
                    'Envío',
                    '${invoice.shippingCost.toStringAsFixed(2)} €',
                  ),
                  _DetailRow(
                    'IVA (${invoice.taxRate.toStringAsFixed(0)}%)',
                    '${invoice.taxAmount.toStringAsFixed(2)} €',
                  ),
                  const Divider(),
                  _DetailRow(
                    'TOTAL',
                    '${invoice.total.toStringAsFixed(2)} €',
                    isBold: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Info adicional
              _DetailSection(
                title: 'Información Adicional',
                children: [
                  _DetailRow('Estado', invoice.statusLabel),
                  if (invoice.paymentMethod != null)
                    _DetailRow('Método de pago', invoice.paymentMethod!),
                  _DetailRow(
                    'Fecha emisión',
                    DateFormat('dd/MM/yyyy HH:mm').format(invoice.issueDate),
                  ),
                  if (invoice.notes != null)
                    _DetailRow('Notas', invoice.notes!),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'draft':
        color = Colors.grey;
        label = 'Borrador';
        break;
      case 'issued':
        color = Colors.blue;
        label = 'Emitida';
        break;
      case 'sent':
        color = Colors.purple;
        label = 'Enviada';
        break;
      case 'paid':
        color = Colors.green;
        label = 'Pagada';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelada';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PANTALLA DE DEVOLUCIONES COMPLETA
// ==========================================

class AdminReturnsScreenComplete extends ConsumerWidget {
  const AdminReturnsScreenComplete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(returnsStatsProvider);
    final pendingAsync = ref.watch(pendingReturnsProvider);
    final receivedAsync = ref.watch(receivedReturnsProvider);
    final completedAsync = ref.watch(completedReturnsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Devoluciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(returnsStatsProvider);
              ref.invalidate(pendingReturnsProvider);
              ref.invalidate(receivedReturnsProvider);
              ref.invalidate(completedReturnsProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  _StatBox(
                    label: 'Pendientes',
                    value: '${stats['pending'] ?? 0}',
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _StatBox(
                    label: 'Recibidos',
                    value: '${stats['received'] ?? 0}',
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 8),
                  _StatBox(
                    label: 'Reembolsados',
                    value: '${stats['refunded'] ?? 0}',
                    color: Colors.green,
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),

            // Pendientes
            _SectionHeader(
              icon: Icons.inventory_2,
              title: 'Pendientes de Recibir',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            pendingAsync.when(
              data: (returns) => returns.isEmpty
                  ? _EmptySection('No hay devoluciones pendientes')
                  : Column(
                      children: returns
                          .map(
                            (r) => _PendingReturnCard(
                              returnModel: r,
                              onMarkReceived: () async {
                                final emailSent = await ref
                                    .read(returnActionsProvider)
                                    .markAsReceived(r.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        emailSent
                                            ? 'Devolución marcada como recibida ✓ Email enviado'
                                            : 'Devolución marcada como recibida (sin email)',
                                      ),
                                      backgroundColor: emailSent
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),

            const SizedBox(height: 32),

            // Recibidos - Pendientes de reembolso
            _SectionHeader(
              icon: Icons.markunread_mailbox,
              title: 'Recibidos - Pendientes de Reembolso',
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            receivedAsync.when(
              data: (returns) => returns.isEmpty
                  ? _EmptySection('No hay devoluciones pendientes de reembolso')
                  : Column(
                      children: returns
                          .map(
                            (r) => _ReceivedReturnCard(
                              returnModel: r,
                              onProcessRefund: () async {
                                // Diálogo de confirmación antes de procesar el reembolso
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirmar Reembolso'),
                                    content: Text(
                                      '¿Procesar reembolso de ${r.refundAmountInEuros.toStringAsFixed(2)} € '
                                      'para la devolución ${r.returnNumber}?\n\n'
                                      'Se enviará un email a ${r.customerEmail}.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text(
                                          'Confirmar Reembolso',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed != true) return;

                                final emailSent = await ref
                                    .read(returnActionsProvider)
                                    .processRefund(returnId: r.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        emailSent
                                            ? 'Reembolso procesado ✓ Email enviado'
                                            : 'Estado actualizado (sin reembolso Stripe ni email)',
                                      ),
                                      backgroundColor: emailSent
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  );
                                }
                              },
                              onReject: () =>
                                  _showRejectDialog(context, ref, r),
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),

            const SizedBox(height: 32),

            // Completados
            _SectionHeader(
              icon: Icons.check_circle,
              title: 'Devoluciones Completadas',
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            completedAsync.when(
              data: (returns) => returns.isEmpty
                  ? _EmptySection('No hay devoluciones completadas')
                  : Column(
                      children: returns
                          .take(10)
                          .map((r) => _CompletedReturnCard(returnModel: r))
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, ReturnModel r) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar Devolución'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¿Estás seguro de rechazar la devolución ${r.returnNumber}?'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Motivo del rechazo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ingresa un motivo')),
                );
                return;
              }
              final emailSent = await ref
                  .read(returnActionsProvider)
                  .rejectReturn(returnId: r.id, reason: controller.text);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      emailSent
                          ? 'Devolución rechazada ✓ Email enviado'
                          : 'Devolución rechazada (sin email)',
                    ),
                    backgroundColor: emailSent ? Colors.green : Colors.orange,
                  ),
                );
              }
            },
            child: const Text(
              'Rechazar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            title,
            style: AppTextStyles.h4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;

  const _EmptySection(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}

class _PendingReturnCard extends StatelessWidget {
  final ReturnModel returnModel;
  final VoidCallback onMarkReceived;

  const _PendingReturnCard({
    required this.returnModel,
    required this.onMarkReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  returnModel.returnNumber,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                _ReturnStatusBadge(status: returnModel.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(returnModel.customerName, style: AppTextStyles.bodyMedium),
            Text(returnModel.customerEmail, style: AppTextStyles.bodySmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Motivo: ${returnModel.reasonLabel}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (returnModel.reasonDetails != null)
                    Text(returnModel.reasonDetails!),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (returnModel.items.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: returnModel.items
                    .map(
                      (item) => Chip(
                        label: Text(
                          '${item.productName} (${item.size ?? 'Única'}) × ${item.quantity}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${returnModel.refundAmountInEuros.toStringAsFixed(2)} €',
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: onMarkReceived,
                    icon: const Icon(Icons.inbox, size: 18),
                    label: const Text(
                      'Marcar Recibido',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceivedReturnCard extends StatelessWidget {
  final ReturnModel returnModel;
  final VoidCallback onProcessRefund;
  final VoidCallback onReject;

  const _ReceivedReturnCard({
    required this.returnModel,
    required this.onProcessRefund,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.purple[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  returnModel.returnNumber,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                _ReturnStatusBadge(status: returnModel.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(returnModel.customerName),
            if (returnModel.items.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: returnModel.items
                    .map(
                      (item) => Chip(
                        label: Text(
                          item.productName,
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${returnModel.refundAmountInEuros.toStringAsFixed(2)} €',
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onReject,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Rechazar'),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: onProcessRefund,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text(
                      'Reembolso',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedReturnCard extends StatelessWidget {
  final ReturnModel returnModel;

  const _CompletedReturnCard({required this.returnModel});

  @override
  Widget build(BuildContext context) {
    final isRefunded = returnModel.status == 'refunded';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isRefunded ? Colors.green[100] : Colors.red[100],
          child: Icon(
            isRefunded ? Icons.check : Icons.close,
            color: isRefunded ? Colors.green : Colors.red,
          ),
        ),
        title: Text(returnModel.returnNumber),
        subtitle: Text(returnModel.customerName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${returnModel.refundAmountInEuros.toStringAsFixed(2)} €'),
            _ReturnStatusBadge(status: returnModel.status),
          ],
        ),
      ),
    );
  }
}

class _ReturnStatusBadge extends StatelessWidget {
  final String status;

  const _ReturnStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.yellow[700]!;
        label = 'Pendiente';
        break;
      case 'in_transit':
        color = Colors.blue;
        label = 'En tránsito';
        break;
      case 'received':
        color = Colors.purple;
        label = 'Recibido';
        break;
      case 'refunded':
        color = Colors.green;
        label = 'Reembolsado';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rechazado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ==========================================
// PANTALLA DE NEWSLETTER COMPLETA
// ==========================================

class AdminNewsletterScreenComplete extends ConsumerStatefulWidget {
  const AdminNewsletterScreenComplete({super.key});

  @override
  ConsumerState<AdminNewsletterScreenComplete> createState() =>
      _AdminNewsletterScreenCompleteState();
}

class _AdminNewsletterScreenCompleteState
    extends ConsumerState<AdminNewsletterScreenComplete> {
  final _subjectController = TextEditingController();
  final _previewController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _previewController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscribersAsync = ref.watch(newsletterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsletter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(newsletterProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            subscribersAsync.when(
              data: (subscribers) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[600]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Colors.white, size: 48),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${subscribers.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Suscriptores activos',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),

            // Formulario de newsletter
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Redactar Newsletter',
                            style: AppTextStyles.h4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Asunto del email *',
                        hintText: 'Ej: ¡Nuevas ofertas de temporada!',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _previewController,
                      decoration: const InputDecoration(
                        labelText: 'Texto de previsualización (opcional)',
                        hintText: 'El texto que aparece junto al asunto',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Contenido del newsletter *',
                        hintText: 'Escribe aquí el contenido...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 10,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.amber[800]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: subscribersAsync.when(
                              data: (subscribers) => Text(
                                'Este email se enviará a ${subscribers.length} suscriptores',
                                style: TextStyle(color: Colors.amber[900]),
                              ),
                              loading: () => const Text('Cargando...'),
                              error: (_, __) => const Text('Error'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSending ? null : _sendNewsletter,
                        icon: _isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                          _isSending ? 'Enviando...' : 'Enviar Newsletter',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lista de suscriptores
            Text('Lista de Suscriptores', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            subscribersAsync.when(
              data: (subscribers) => subscribers.isEmpty
                  ? _EmptySection('No hay suscriptores activos')
                  : Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subscribers.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final sub = subscribers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: const Icon(
                                Icons.email,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(sub.email),
                            subtitle: Text(
                              'Suscrito: ${DateFormat('dd/MM/yyyy').format(sub.subscribedAt)}',
                            ),
                          );
                        },
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendNewsletter() async {
    if (_subjectController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa el asunto y contenido')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final subscribers = await ref.read(newsletterProvider.future);
      final recipients = subscribers
          .map((s) => {'email': s.email, 'name': null})
          .toList();

      // Llamar al API de la web para enviar el newsletter
      final response = await http.post(
        Uri.parse('${AppConstants.webApiBaseUrl}/api/admin/send-newsletter'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'subject': _subjectController.text,
          'preview': _previewController.text,
          'content': _contentController.text,
          'recipients': recipients,
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Newsletter enviado correctamente!'),
              backgroundColor: Colors.green,
            ),
          );
          _subjectController.clear();
          _previewController.clear();
          _contentController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al enviar: ${_extractNewsletterError(response.body)}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  String _extractNewsletterError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error']?.toString();
        if (error != null && error.isNotEmpty) return error;
        final message = decoded['message']?.toString();
        if (message != null && message.isNotEmpty) return message;
      }
    } catch (_) {}
    return body;
  }
}

// ==========================================
// PANTALLA DE CONFIGURACIÓN COMPLETA
// ==========================================

class AdminSettingsScreenComplete extends ConsumerStatefulWidget {
  const AdminSettingsScreenComplete({super.key});

  @override
  ConsumerState<AdminSettingsScreenComplete> createState() =>
      _AdminSettingsScreenCompleteState();
}

class _AdminSettingsScreenCompleteState
    extends ConsumerState<AdminSettingsScreenComplete> {
  final _thresholdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashOffersAsync = ref.watch(flashOffersEnabledProvider);
    final thresholdAsync = ref.watch(lowStockThresholdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ofertas Flash
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.flash_on,
                        color: Colors.amber[800],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ofertas Flash', style: AppTextStyles.h4),
                          const SizedBox(height: 4),
                          Text(
                            'Controla la visibilidad de la sección "Ofertas Flash" en la página de inicio',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flashOffersAsync.when(
                      data: (enabled) => Switch(
                        value: enabled,
                        onChanged: (value) async {
                          setState(() => _isLoading = true);
                          await ref
                              .read(settingsActionsProvider)
                              .toggleFlashOffers(value);
                          setState(() => _isLoading = false);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? 'Ofertas Flash activadas'
                                      : 'Ofertas Flash desactivadas',
                                ),
                              ),
                            );
                          }
                        },
                        activeThumbColor: Colors.amber[600],
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Icon(Icons.error),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Umbral de Stock Bajo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.inventory,
                            color: Colors.orange[800],
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Umbral de Stock Bajo',
                                style: AppTextStyles.h4,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Define cuántas unidades se consideran "stock bajo" para mostrar alertas',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    thresholdAsync.when(
                      data: (threshold) {
                        _thresholdController.text = threshold.toString();
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _thresholdController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Umbral (unidades)',
                                  hintText: 'Ej: 5',
                                  border: const OutlineInputBorder(),
                                  suffixText: 'uds',
                                  helperText: 'Actual: $threshold unidades',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      final value = int.tryParse(
                                        _thresholdController.text,
                                      );
                                      if (value == null ||
                                          value < 1 ||
                                          value > 100) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'El umbral debe ser entre 1 y 100',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() => _isLoading = true);
                                      await ref
                                          .read(settingsActionsProvider)
                                          .updateLowStockThreshold(value);
                                      setState(() => _isLoading = false);
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Umbral actualizado'),
                                          ),
                                        );
                                      }
                                    },
                              child: const Text('Guardar'),
                            ),
                          ],
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (err, _) => Text('Error: $err'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Info del sistema
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.info,
                            color: Colors.blue[800],
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            'Información del Sistema',
                            style: AppTextStyles.h4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _InfoRow('Versión de la App', '1.0.0'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PANTALLA DE ALERTAS DE STOCK BAJO
// ==========================================

class AdminLowStockAlertsScreen extends ConsumerWidget {
  const AdminLowStockAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowStockAsync = ref.watch(lowStockSizesProvider);
    final thresholdAsync = ref.watch(lowStockThresholdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas de Stock Bajo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(lowStockSizesProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con info del umbral
          thresholdAsync.when(
            data: (threshold) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.orange[50],
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mostrando tallas con menos de $threshold unidades',
                      style: TextStyle(color: Colors.orange[900]),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar a configuración para cambiar umbral
                      context.go('/admin/settings');
                    },
                    child: const Text('Cambiar'),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          // Lista de alertas
          Expanded(
            child: lowStockAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '¡Todas las tallas tienen stock suficiente!',
                          style: AppTextStyles.h4.copyWith(color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No hay alertas de stock bajo',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                // Agrupar por nivel de urgencia
                final outOfStock = items.where((i) => i.stock == 0).toList();
                final critical = items
                    .where((i) => i.stock > 0 && i.stock <= 2)
                    .toList();
                final warning = items.where((i) => i.stock > 2).toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (outOfStock.isNotEmpty) ...[
                      _AlertSection(
                        icon: Icons.error,
                        title: 'SIN STOCK',
                        color: Colors.red,
                        items: outOfStock,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (critical.isNotEmpty) ...[
                      _AlertSection(
                        icon: Icons.warning_amber,
                        title: 'STOCK CRÍTICO (1-2 uds)',
                        color: Colors.orange,
                        items: critical,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (warning.isNotEmpty) ...[
                      _AlertSection(
                        icon: Icons.trending_down,
                        title: 'STOCK BAJO',
                        color: Colors.amber,
                        items: warning,
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<dynamic> items;

  const _AlertSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          final productSize = item;
          final hasImage =
              productSize.productImage != null &&
              productSize.productImage!.isNotEmpty;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.push('/admin/products/${productSize.productId}/edit');
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: hasImage
                          ? CachedNetworkImage(
                              imageUrl: productSize.productImage!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productSize.productName ??
                                'Producto #${productSize.productId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Talla ${productSize.size}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Stock badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: productSize.stock == 0 ? Colors.red : color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        productSize.stock == 0
                            ? 'AGOTADO'
                            : '${productSize.stock} uds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
