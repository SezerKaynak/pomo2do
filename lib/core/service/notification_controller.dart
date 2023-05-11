import 'package:alarm/alarm.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:pomotodo/l10n/app_l10n.dart';

class NotificationController {
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'close') {
      await Alarm.stop(10);
    }
  }

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic',
            channelName: 'Pomodoro Notifications',
            channelDescription: 'Notification channel for pomodoro',
            channelShowBadge: true,
            enableVibration: true,
            importance: NotificationImportance.High)
      ],
    );
  }

  Future<void> createNotification(int index, int time, L10n l10n,
      bool notificationPermission, bool alarmPermission) async {
    NotificationContent notificationContent;

    final alarmSettings = AlarmSettings(
        id: 10,
        dateTime: DateTime.now().add(Duration(seconds: time)),
        assetAudioPath: 'assets/alarms/android_alarm.mp3',
        loopAudio: true,
        vibrate: true,
        fadeDuration: 4.0,
        enableNotificationOnKill: false);

    switch (index) {
      case 1:
        notificationContent = NotificationContent(
          id: 0,
          channelKey: 'basic',
          title: l10n.shortBreakDone,
          body: l10n.nextPomodoro,
          autoDismissible: false,
          wakeUpScreen: true,
        );
        break;
      case 2:
        notificationContent = NotificationContent(
          id: 0,
          channelKey: 'basic',
          title: l10n.longBreakDone,
          body: l10n.pomodoroNextCycle,
          autoDismissible: false,
          wakeUpScreen: true,
        );
        break;
      default:
        notificationContent = NotificationContent(
          id: 0,
          channelKey: 'basic',
          title: l10n.pomodoroDone,
          body: l10n.nextBreak,
          autoDismissible: false,
          wakeUpScreen: true,
        );
    }

    if (notificationPermission && alarmPermission) {
      AwesomeNotifications()
          .createNotification(
        content: notificationContent,
        actionButtons: [
          NotificationActionButton(key: "close", label: l10n.stopAlarm)
        ],
        schedule: NotificationCalendar.fromDate(
          date: DateTime.now().add(
            Duration(seconds: time),
          ),
        ),
      )
          .then(
        (value) {
          Alarm.set(alarmSettings: alarmSettings);
        },
      );
    } else if (notificationPermission) {
      AwesomeNotifications().createNotification(
        content: notificationContent,
        schedule: NotificationCalendar.fromDate(
          date: DateTime.now().add(
            Duration(seconds: time),
          ),
        ),
      );
    } else if (alarmPermission) {
      Alarm.set(alarmSettings: alarmSettings);
    }
  }
}
