import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/data/preference/preference_manager.dart';
import 'package:restaurant_flutter_app/utils/background_service.dart';

class SettingProvider extends ChangeNotifier {
  final PreferenceManager preferenceManager = PreferenceManager();
  final BackgroundService _service = BackgroundService();

  bool _stateNotify = false;

  bool get stateNotify => _stateNotify;




  Future<void> getStateNotify() async {
    _stateNotify = await  preferenceManager.getStateNotifySchedule();
    notifyListeners();
  }

  Future<void> setStateNotify(bool state) async {
    await preferenceManager.setStateNotifySchedule(state);
    _stateNotify = state;
    notifyListeners();
  }
}