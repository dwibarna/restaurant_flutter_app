import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_flutter_app/common/navigation.dart';
import 'package:restaurant_flutter_app/presentation/screen/favorite/favorite_screen.dart';
import 'package:restaurant_flutter_app/presentation/screen/setting/setting_screen.dart';

import 'utils/background_service.dart';
import 'utils/notification_helper.dart';
import 'presentation/screen/detail/detail_screen.dart';
import 'presentation/screen/main/main_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/mainScreen': (context) => const MainScreen(),
        '/detailScreen': (context) =>
            DetailScreen(ModalRoute.of(context)?.settings.arguments as String),
        '/favoriteScreen': (context) => const FavoriteScreen(),
        '/settingScreen': (context) => const SettingScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then(
        (value) => Navigator.pushReplacementNamed(context, '/mainScreen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                "assets/restaurant_logo.png",
              ),
              width: 300,
            ),
            const SizedBox(
              height: 64,
            ),
            SpinKitHourGlass(
              color: Colors.green.shade200,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}
