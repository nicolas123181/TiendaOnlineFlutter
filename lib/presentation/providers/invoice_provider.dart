import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/invoice.dart';
import '../../data/repositories/invoice_repository.dart';
import 'auth_provider.dart';

/// Provider del repositorio de facturas
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository();
});

/// Provider de las facturas del usuario
final userInvoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return [];

  final repository = ref.watch(invoiceRepositoryProvider);
  return await repository.getUserInvoices(limit: 50);
});

/// Provider de una factura por ID
final invoiceByIdProvider =
    FutureProvider.family<Invoice?, String>((ref, invoiceId) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return await repository.getInvoiceById(invoiceId);
});
