import 'package:flutter/material.dart';
import 'package:pomotodo/utils/notifications/notification_preference.dart';

class NotificationSettingsController extends ChangeNotifier {
  NotificationPreference notificationSettingsPreference =
      NotificationPreference();

  bool _alarmSetting = false;
  bool _notificationSetting = false;

  bool get alarmSetting => _alarmSetting;
  bool get notificationSetting => _notificationSetting;

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
}
