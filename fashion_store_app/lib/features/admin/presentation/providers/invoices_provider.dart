// Provider simplificado para gestión de facturas

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/invoice.dart';

/// Provider para listar todas las facturas
final invoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('invoices')
      .select('*')
      .order('created_at', ascending: false);

  return (response as List).map((json) => Invoice.fromJson(json)).toList();
});

/// Provider para obtener factura por ID de pedido
final invoiceByOrderProvider = FutureProvider.family<Invoice?, int>((
  ref,
  orderId,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('invoices')
      .select('*')
      .eq('order_id', orderId)
      .maybeSingle();

  return response != null ? Invoice.fromJson(response) : null;
});

/// Provider para acciones de facturas
final invoiceActionsProvider = Provider((ref) => InvoiceActions(ref));

class InvoiceActions {
  final Ref ref;

  InvoiceActions(this.ref);

  Future<Invoice> generateInvoice(int orderId) async {
    final supabase = ref.read(supabaseClientProvider);

    // Obtener información del pedido
    final orderResponse = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', orderId)
        .single();

    // Generar número de factura
    final countResponse = await supabase.from('invoices').select('id');

    final count = (countResponse as List).length;
    final invoiceNumber =
        'INV-${DateTime.now().year}-${(count + 1).toString().padLeft(6, '0')}';

    // Crear factura
    final invoiceData = {
      'order_id': orderId,
      'invoice_number': invoiceNumber,
      'customer_name': orderResponse['customer_name'],
      'customer_email': orderResponse['customer_email'],
      'customer_address': orderResponse['shipping_address'],
      'total_amount': orderResponse['total_amount'],
      'tax_amount': orderResponse['total_amount'] * 0.21, // 21% IVA
      'subtotal': orderResponse['total_amount'] * 0.79,
      'items': orderResponse['order_items'],
    };

    final response = await supabase
        .from('invoices')
        .insert(invoiceData)
        .select()
        .single();

    ref.invalidate(invoicesProvider);
    ref.invalidate(invoiceByOrderProvider(orderId));

    return Invoice.fromJson(response);
  }

  Future<void> sendInvoiceEmail(int invoiceId) async {
    // TODO: Implementar envío de email con la factura
    throw UnimplementedError('Envío de facturas por email en desarrollo');
  }
}
