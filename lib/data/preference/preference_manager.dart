import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  late SharedPreferences preferences;

  Future<void> setStateNotifySchedule(bool state) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setBool('stateNotify', state);
  }

  Future<bool> getStateNotifySchedule() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getBool('stateNotify') ?? false;
  }
}
