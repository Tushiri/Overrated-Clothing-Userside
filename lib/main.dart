import 'package:emart_app/views/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'consts/consts.dart';
import 'package:sellerside_app/services/store_services.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

final storeServices = StoreServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  String? deviceToken = await FirebaseMessaging.instance.getToken();
  logger.w('FCM Device Token: $deviceToken');

  await sendInitialNotification(deviceToken);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d("Handling a background message: ${message.messageId}");
}

Future<void> sendInitialNotification(String? deviceToken) async {
  if (deviceToken != null) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await storeServices.sendNotification(
        'Order Status Update',
        'Your order is now Confirmed',
        userId,
        deviceToken,
      );
    } else {
      logger.w('User ID is null. Cannot send initial notification.');
    }
  } else {
    logger.w('Device token is null. Cannot send initial notification.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        fontFamily: regular,
      ),
      home: const EmartApp(),
    );
  }
}

class EmartApp extends StatelessWidget {
  const EmartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreen(),
    );
  }
}
