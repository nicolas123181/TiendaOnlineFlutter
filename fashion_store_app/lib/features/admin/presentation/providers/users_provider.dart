// Provider para gestión de usuarios

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/admin_stats.dart';

/// Provider para listar usuarios con estadísticas
final usersStatsProvider = FutureProvider<List<UserStats>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  // Obtener todos los pedidos con información del cliente
  final ordersResponse = await supabase
      .from('orders')
      .select('customer_email, customer_name, customer_phone, created_at')
      .order('created_at', ascending: false);

  final orders = ordersResponse as List;

  // Obtener suscriptores del newsletter
  final subscribersResponse = await supabase
      .from('newsletter_subscribers')
      .select('email');

  final subscriberEmails = (subscribersResponse as List)
      .map((s) => s['email'] as String)
      .toSet();

  // Agrupar por email
  final usersMap = <String, Map<String, dynamic>>{};

  for (var order in orders) {
    final email = order['customer_email'] as String;
    if (usersMap.containsKey(email)) {
      usersMap[email]!['orders_count']++;
      usersMap[email]!['first_order'] = order['created_at'];
    } else {
      usersMap[email] = {
        'email': email,
        'name': order['customer_name'],
        'phone': order['customer_phone'],
        'orders_count': 1,
        'last_order': order['created_at'],
        'first_order': order['created_at'],
        'is_newsletter_subscriber': subscriberEmails.contains(email),
      };
    }
  }

  final users = usersMap.values.map((u) => UserStats.fromJson(u)).toList();

  // Ordenar por última compra
  users.sort((a, b) => b.lastOrder.compareTo(a.lastOrder));

  return users;
});

/// Provider para estadísticas totales de usuarios
final usersTotalStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final users = await ref.watch(usersStatsProvider.future);
  final supabase = ref.read(supabaseClientProvider);

  final ordersResponse = await supabase.from('orders').select('id');
  final totalOrders = (ordersResponse as List).length;

  final subscribersResponse = await supabase
      .from('newsletter_subscribers')
      .select('id')
      .eq('is_active', true);
  final totalSubscribers = (subscribersResponse as List).length;

  return {
    'total_users': users.length,
    'total_orders': totalOrders,
    'total_subscribers': totalSubscribers,
  };
});
