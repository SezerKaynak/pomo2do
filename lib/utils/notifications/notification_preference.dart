import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreference {
  static const alarm_status = "alarm_status";
  static const notification_status = "notification_status";
  static const warn_status = "warn_status";
  static const spotify_status = "spotify_status";
  static const pause_spotify_status = "pause_spotify_status";

  setAlarmSetting(bool alarmValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(alarm_status, alarmValue);
  }

  setNotificationSetting(bool notificationValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(notification_status, notificationValue);
  }

  setWarnSetting(bool warnValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(warn_status, warnValue);
  }

  setSpotifySetting(bool spotifyValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(spotify_status, spotifyValue);
  }

  setPauseSpotifySetting(bool pauseSpotifyValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(pause_spotify_status, pauseSpotifyValue);
  }

  Future<List<bool>> getSetting() async {
    List<bool> settingList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    settingList.addAll([
      prefs.getBool(alarm_status) ?? false,
      prefs.getBool(notification_status) ?? false,
      prefs.getBool(warn_status) ?? true,
      prefs.getBool(spotify_status) ?? true,
      prefs.getBool(pause_spotify_status) ?? true,
    ]);
    return settingList;
  }
}
