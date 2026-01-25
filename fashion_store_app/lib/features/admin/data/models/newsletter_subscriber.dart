// Modelo para Suscriptores Newsletter

class NewsletterSubscriber {
  final int id;
  final String email;
  final bool isActive;
  final DateTime subscribedAt;
  final DateTime? unsubscribedAt;

  NewsletterSubscriber({
    required this.id,
    required this.email,
    required this.isActive,
    required this.subscribedAt,
    this.unsubscribedAt,
  });

  factory NewsletterSubscriber.fromJson(Map<String, dynamic> json) {
    return NewsletterSubscriber(
      id: json['id'],
      email: json['email'],
      isActive: json['is_active'] ?? true,
      subscribedAt: DateTime.parse(json['subscribed_at']),
      unsubscribedAt: json['unsubscribed_at'] != null
          ? DateTime.parse(json['unsubscribed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_active': isActive,
      'subscribed_at': subscribedAt.toIso8601String(),
      'unsubscribed_at': unsubscribedAt?.toIso8601String(),
    };
  }
}
