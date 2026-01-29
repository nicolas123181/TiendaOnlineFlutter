import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../config/constants/app_constants.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../data/models/return_model.dart';

/// Provider para obtener devoluciones (admin)
final returnsAdminProvider = FutureProvider<List<ReturnRequest>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('returns')
      .select('*')
      .order('created_at', ascending: false);

  return (response as List)
      .map((json) => ReturnRequest.fromJson(json as Map<String, dynamic>))
      .toList();
});

/// Acciones admin para devoluciones
final returnAdminActionsProvider = Provider((ref) {
  return ReturnAdminActions();
});

class ReturnAdminActions {
  Future<void> updateReturnStatus({
    required int returnId,
    required String status,
    String? adminNotes,
    int? refundAmount,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.webApiBaseUrl}/api/admin/update-return'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'returnId': returnId,
        'status': status,
        'adminNotes': adminNotes,
        'refundAmount': refundAmount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error actualizando devolución: ${response.body}');
    }
  }
}
