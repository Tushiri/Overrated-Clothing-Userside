import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

class FCMService {
  static final Logger _logger = Logger();

  static void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  static void _handleMessage(RemoteMessage message) {
    _logger.d('Received message: $message');
    if (message.notification != null &&
        message.notification!.title != null &&
        message.notification!.body != null) {
      _logger.d(
          'Notification: ${message.notification!.title} ${message.notification!.body}');
    }

    // ignore: unnecessary_null_comparison
    if (message.data != null && message.data.isNotEmpty) {
      _logger.d('Data: ${message.data}');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
