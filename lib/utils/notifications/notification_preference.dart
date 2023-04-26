import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreference {
  static const alarm_status = "alarm_status";
  static const notification_status = "notification_status";

  setAlarmSetting(bool alarmValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(alarm_status, alarmValue);
  }

  setNotificationSetting(bool notificationValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(notification_status, notificationValue);
  }

  Future<List<bool>> getSetting() async {
    List<bool> settingList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    settingList.addAll([
      prefs.getBool(alarm_status) ?? false,
      prefs.getBool(notification_status) ?? false
    ]);
    return settingList;
  }
}
