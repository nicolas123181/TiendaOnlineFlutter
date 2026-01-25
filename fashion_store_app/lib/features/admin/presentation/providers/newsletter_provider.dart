// Provider simplificado para gestión de newsletter

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/newsletter_subscriber.dart';

/// Provider para listar suscriptores
final newsletterProvider = FutureProvider<List<NewsletterSubscriber>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('newsletter_subscribers')
      .select('*')
      .order('subscribed_at', ascending: false);

  return (response as List)
      .map((json) => NewsletterSubscriber.fromJson(json))
      .toList();
});

/// Provider para estadísticas de newsletter
final newsletterStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final activeResponse = await supabase
      .from('newsletter_subscribers')
      .select('id')
      .eq('is_active', true);

  final inactiveResponse = await supabase
      .from('newsletter_subscribers')
      .select('id')
      .eq('is_active', false);

  return {
    'active': (activeResponse as List).length,
    'inactive': (inactiveResponse as List).length,
  };
});

/// Provider para acciones de newsletter
final newsletterActionsProvider = Provider((ref) => NewsletterActions(ref));

class NewsletterActions {
  final Ref ref;

  NewsletterActions(this.ref);

  Future<void> toggleSubscriber(int id, bool isActive) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('newsletter_subscribers')
        .update({'is_active': !isActive})
        .eq('id', id);

    ref.invalidate(newsletterProvider);
    ref.invalidate(newsletterStatsProvider);
  }

  Future<void> deleteSubscriber(int id) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase.from('newsletter_subscribers').delete().eq('id', id);

    ref.invalidate(newsletterProvider);
    ref.invalidate(newsletterStatsProvider);
  }

  Future<String> exportSubscribers() async {
    final subscribers = await ref.read(newsletterProvider.future);

    final csv = subscribers.map((s) => '${s.email},${s.isActive}').join('\n');

    return 'email,active\n$csv';
  }
}
