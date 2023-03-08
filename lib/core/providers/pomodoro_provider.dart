import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';

class PageUpdate extends ChangeNotifier with DatabaseService {
  bool skipButtonVisible = false;
  bool startStop = true;
  bool onWillPop = true;
  String startDate = "";
  final String basla = "BAŞLAT";
  final String durdur = "DURDUR";
  int countDown = 0, countDown2 = 0, countDown3 = 0;
  bool timerWorking = false;

  void startButton(CountDownController controller, int time) {
    controller.resume();
    countDown = controller.getTimeInSeconds();
    skipButtonVisible = true;
    startStop = false;
    startDate = getTime();
    notifyListeners();
  }

  void startOrStop(int time, CountDownController controller, TaskModel task,
      TabController tabController, int longBreakTimerSelect) {
    if (startStop == true) {
      startButton(controller, time);
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

  Widget callText() {
    if (startStop == true) {
      return Text(basla);
    } else {
      return Text(durdur);
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

  void stop(CountDownController controller, TaskModel task, int time,
      TabController tabController, int longBreakNumberSelect) async {
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
          tabController.animateTo(1);
        } else if (passingTime == time) {
          tabController.animateTo(2);
        }
        break;
      case 1:
        if (timerWorking) {
          print("gökalp");
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
          tabController.animateTo(0);
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
        break;
      default:
    }
    notifyListeners();
  }
}
