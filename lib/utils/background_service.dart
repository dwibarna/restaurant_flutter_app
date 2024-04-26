import 'dart:math';
import 'dart:ui';
import 'dart:isolate';


import '../data/api/api_service.dart';
import '../main.dart';
import 'notification_helper.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();

    var result = await ApiService(http.Client()).getListRestaurant();
    int randomIndex = Random().nextInt(result.length);
    var randomResult = result[randomIndex];

    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin,
        randomResult
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
