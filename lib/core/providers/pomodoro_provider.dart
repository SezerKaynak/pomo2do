import 'package:alarm/alarm.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:pomotodo/core/service/google_ads.dart';
import 'package:pomotodo/core/service/notification_controller.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:quickalert/quickalert.dart';

class PageUpdate extends ChangeNotifier with DatabaseService {
  PageUpdate({required this.context, this.l10n});

  bool skipButtonVisible = false;
  bool startStop = true;
  bool onWillPop = true;
  String startDate = "";
  final String basla = "BAŞLAT";
  final String durdur = "DURDUR";
  int countDown = 0, countDown2 = 0, countDown3 = 0;
  bool timerWorking = false;
  bool isAlarmRinging = true;
  final BuildContext context;
  final L10n? l10n;

  void startButton(CountDownController controller, int time, int index) {
    NotificationController().createNotification(index, time, l10n!);
    GoogleAds().loadInterstitialAd(showAfterLoad: true);
    controller.resume();
    countDown = controller.getTimeInSeconds();
    skipButtonVisible = true;
    startStop = false;
    startDate = getTime();
    notifyListeners();
  }

  void startOrStop(
    int time,
    CountDownController controller,
    TaskModel task,
    TabController tabController,
    int longBreakTimerSelect,
  ) {
    if (startStop == true) {
      startButton(controller, time, tabController.index);
      onWillPop = false;
      notifyListeners();
    } else {
      stop(controller, task, time, tabController, longBreakTimerSelect);
      onWillPop = true;
      skipButtonVisible = false;
      notifyListeners();
    }
  }

  void restartTimer(CountDownController controller, int newDuration) {
    controller.restart(duration: newDuration);
    countDown = controller.getTimeInSeconds();
    skipButtonVisible = true;
    startStop = false;
    onWillPop = false;
    notifyListeners();
  }

  Widget callText(BuildContext context) {
    if (startStop == true) {
      return Text(L10n.of(context)!.start);
    } else {
      return Text(L10n.of(context)!.stop);
    }
  }

  void floatingActionOnPressed(TaskModel task, int pomodoroCount) {
    task.pomodoroCount = pomodoroCount;
    updateTask(task);
    notifyListeners();
  }

  String getTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("dd-MM-yyyy");
    final String formattedDate = formatter.format(now);
    return formattedDate;
  }

  showQuickAlert(
      TabController tabController,
      CountDownController controller,
      String title,
      String text,
      String confirmBtnText,
      String cancelBtnText,
      int tabIndex) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: text,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        Alarm.stop(10);
        AwesomeNotifications().dismiss(0);
        tabController.animateTo(tabIndex);
        Navigator.pop(context);
      },
      onCancelBtnTap: () {
        Alarm.stop(10);
        AwesomeNotifications().dismiss(0);
        controller.restart();
        controller.pause();
        Navigator.pop(context);
      },
    );
  }

  void stop(
    CountDownController controller,
    TaskModel task,
    int time,
    TabController tabController,
    int longBreakNumberSelect,
  ) async {
    startStop = true;
    notifyListeners();
    controller.pause();
    int passingTime;
    int screenOffCounter = 0;

    switch (tabController.index) {
      case 0:
        if (timerWorking) {
          screenOffCounter = countDown2 - countDown;
        }

        countDown2 = controller.getTimeInSeconds();

        passingTime = screenOffCounter + countDown - countDown2;

        if (getTime() == startDate) {
          await updateTaskStatistics(task, passingTime, startDate, 0);
        } else {
          await updateTaskStatistics(task, passingTime, getTime(), 0);
        }

        if (passingTime == time && task.pomodoroCount < longBreakNumberSelect) {
          showQuickAlert(
            tabController,
            controller,
            l10n!.shortBreak,
            l10n!.shortBreakSubtitle,
            l10n!.alertApprove,
            l10n!.alertReject,
            1,
          );
        } else if (passingTime == time) {
          showQuickAlert(
            tabController,
            controller,
            l10n!.longBreak,
            l10n!.longBreakSubtitle,
            l10n!.alertApprove,
            l10n!.alertReject,
            2,
          );
        } else {
          AwesomeNotifications().cancel(0);
          Alarm.stop(10);
        }
        break;
      case 1:
        if (timerWorking) {
          screenOffCounter = countDown2 - countDown;
        }

        countDown2 = controller.getTimeInSeconds();

        passingTime = screenOffCounter + countDown - countDown2;

        if (getTime() == startDate) {
          await updateTaskStatistics(task, passingTime, startDate, 1);
        } else {
          await updateTaskStatistics(task, passingTime, getTime(), 1);
        }

        if (passingTime == time) {
          showQuickAlert(
            tabController,
            controller,
            "Kısa ara bitti",
            "Sıradaki pomodoro sayacına geçilsin mi?",
            l10n!.alertApprove,
            l10n!.alertReject,
            0,
          );
        } else {
          AwesomeNotifications().cancel(0);
          Alarm.stop(10);
        }
        break;
      case 2:
        if (timerWorking) {
          screenOffCounter = countDown2 - countDown;
        }

        countDown2 = controller.getTimeInSeconds();

        passingTime = screenOffCounter + countDown - countDown2;

        if (getTime() == startDate) {
          await updateTaskStatistics(task, passingTime, startDate, 2);
        } else {
          await updateTaskStatistics(task, passingTime, getTime(), 2);
        }

        if (time == passingTime) {
          showQuickAlert(
              tabController,
              controller,
              "Pomodoro döngüsü tamamlandı",
              "Sıradaki döngüye geçilsin mi?",
              l10n!.alertApprove,
              l10n!.alertReject,
              0);
          floatingActionOnPressed(task, 0);
        } else {
          AwesomeNotifications().cancel(0);
          Alarm.stop(10);
        }

        break;
      default:
    }
    notifyListeners();
  }
}
