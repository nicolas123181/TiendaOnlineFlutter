import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Servicio de notificaciones push locales
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Canales de notificación
  static const String _orderChannelId = 'orders';
  static const String _orderChannelName = 'Pedidos';
  static const String _orderChannelDescription =
      'Notificaciones de estado de pedidos';

  static const String _promotionChannelId = 'promotions';
  static const String _promotionChannelName = 'Promociones';
  static const String _promotionChannelDescription =
      'Ofertas y promociones especiales';

  static const String _generalChannelId = 'general';
  static const String _generalChannelName = 'General';
  static const String _generalChannelDescription = 'Notificaciones generales';

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    // Inicializar timezone para notificaciones programadas
    initializeTimezone();

    // Configuración para Android
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );

    // Crear canales de notificación en Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }

    _initialized = true;
  }

  /// Crea los canales de notificación para Android
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Canal de pedidos
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _orderChannelId,
          _orderChannelName,
          description: _orderChannelDescription,
          importance: Importance.high,
          playSound: true,
        ),
      );

      // Canal de promociones
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _promotionChannelId,
          _promotionChannelName,
          description: _promotionChannelDescription,
          importance: Importance.defaultImportance,
        ),
      );

      // Canal general
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _generalChannelId,
          _generalChannelName,
          description: _generalChannelDescription,
          importance: Importance.defaultImportance,
        ),
      );
    }
  }

  /// Solicita permisos de notificación
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return false;
  }

  /// Verifica si los permisos están otorgados
  Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      return result?.isEnabled ?? false;
    }
    return false;
  }

  /// Muestra una notificación de actualización de pedido
  Future<void> showOrderNotification({
    required String orderId,
    required String status,
    required String title,
    required String body,
  }) async {
    await _showNotification(
      id: orderId.hashCode,
      title: title,
      body: body,
      channelId: _orderChannelId,
      channelName: _orderChannelName,
      payload: 'order:$orderId',
    );
  }

  /// Muestra una notificación de promoción
  Future<void> showPromotionNotification({
    required String promoId,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    await _showNotification(
      id: promoId.hashCode,
      title: title,
      body: body,
      channelId: _promotionChannelId,
      channelName: _promotionChannelName,
      payload: 'promo:$promoId',
      bigPicture: imageUrl,
    );
  }

  /// Muestra una notificación general
  Future<void> showGeneralNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showNotification(
      id: id,
      title: title,
      body: body,
      channelId: _generalChannelId,
      channelName: _generalChannelName,
      payload: payload,
    );
  }

  /// Muestra una notificación
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    String? payload,
    String? bigPicture,
  }) async {
    // Configuración de estilo para Android
    AndroidNotificationDetails androidDetails;

    if (bigPicture != null) {
      androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicture),
          contentTitle: title,
          summaryText: body,
        ),
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body),
      );
    }

    // Configuración para iOS
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Cancela una notificación específica
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancela todas las notificaciones
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Obtiene las notificaciones pendientes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Callback cuando se toca una notificación
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    // Parsear el payload para determinar la acción
    // Formato: "tipo:id" (ej: "order:123", "promo:abc")
    final parts = payload.split(':');
    if (parts.length != 2) return;

    final type = parts[0];
    final id = parts[1];

    _handleNotificationTap(type, id);

    // TODO: Implementar navegación según el tipo
    // Esto se manejará con un callback o stream que escuche la app
    switch (type) {
      case 'order':
        // Navegar a detalle de pedido
        break;
      case 'promo':
        // Navegar a la promoción
        break;
      default:
        break;
    }
  }

  static void _handleNotificationTap(String type, String id) {
    // TODO: Implementar navegación según el tipo y el id
  }

  /// Callback para notificaciones en background
  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTap(NotificationResponse response) {
    // Manejar tap en background - similar a _onNotificationTap
  }

  /// Programa una notificación para más tarde
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final androidDetails = const AndroidNotificationDetails(
      _generalChannelId,
      _generalChannelName,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _convertToTZDateTime(scheduledTime),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Convierte DateTime a TZDateTime
  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }
}

/// Inicializa el timezone para notificaciones programadas
void initializeTimezone() {
  tz_data.initializeTimeZones();
}
