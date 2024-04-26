import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/data/preference/preference_manager.dart';

import '../utils/background_service.dart';
import '../utils/date_time_helper.dart';

class SettingProvider extends ChangeNotifier {
  final PreferenceManager preferenceManager = PreferenceManager();

  bool _stateNotify = false;

  bool get stateNotify => _stateNotify;

  Future<void> getStateNotify() async {
    _stateNotify = await preferenceManager.getStateNotifySchedule();
    notifyListeners();
  }

  Future<void> setStateNotify(bool state) async {
    await preferenceManager.setStateNotifySchedule(state);
    _stateNotify = state;
    getStateNotify();
    notifyListeners();
  }

  Future<bool> scheduledNotification(bool state) async {
    if (state) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
