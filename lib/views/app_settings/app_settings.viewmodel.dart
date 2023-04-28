import 'package:flutter/material.dart';
import 'package:pomotodo/utils/notifications/notification_preference.dart';

class AppSettingsController extends ChangeNotifier {
  NotificationPreference notificationSettingsPreference =
      NotificationPreference();

  bool _alarmSetting = true;
  bool _notificationSetting = true;
  bool _warnSetting = true;
  bool _spotifySetting = true;
  bool _pauseSpotifySetting = true;

  bool get alarmSetting => _alarmSetting;
  bool get notificationSetting => _notificationSetting;
  bool get warnSetting => _warnSetting;
  bool get spotifySetting => _spotifySetting;
  bool get pauseSpotifySetting => _pauseSpotifySetting;

  set alarmSetting(bool value) {
    _alarmSetting = value;
    notificationSettingsPreference.setAlarmSetting(value);
    notifyListeners();
  }

  set notificationSetting(bool value) {
    _notificationSetting = value;
    notificationSettingsPreference.setNotificationSetting(value);
    notifyListeners();
  }

  set warnSetting(bool value) {
    _warnSetting = value;
    notificationSettingsPreference.setWarnSetting(value);
    notifyListeners();
  }

  set spotifySetting(bool value) {
    _spotifySetting = value;
    notificationSettingsPreference.setSpotifySetting(value);
    notifyListeners();
  }

  set pauseSpotifySetting(bool value) {
    _pauseSpotifySetting = value;
    notificationSettingsPreference.setPauseSpotifySetting(value);
    notifyListeners();
  }
}
