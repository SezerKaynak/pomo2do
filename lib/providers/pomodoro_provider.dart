import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_application_1/service/database_service.dart';

class PageUpdate extends ChangeNotifier with DatabaseService {
  bool skipButtonVisible = false;
  bool startStop = true;
  bool onWillPop = true;
  final String basla = "BAŞLAT";
  final String durdur = "DURDUR";

  void startButton(CountDownController controller, int time) {
    controller.resume();
    skipButtonVisible = true;
    startStop = false;

    notifyListeners();
  }

  void startOrStop(int time, CountDownController controller, TaskModel task,
      TabController tabController, int longBreakTimerSelect) {
    if (startStop == true) {
      startButton(controller, time);
      onWillPop = false;
    } else {
      stop(controller, task, time, tabController, longBreakTimerSelect);
      onWillPop = true;
      skipButtonVisible = false;
    }
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

  void stop(CountDownController controller, TaskModel task, int time,
      TabController tabController, int longBreakNumberSelect) async {
    startStop = true;
    controller.pause();
    int passingTime;

    switch (tabController.index) {
      case 0:
        var countDown = controller.getTimeInSeconds();
        passingTime = time - countDown;
        task.taskPassingTime =
            (passingTime + int.parse(task.taskPassingTime)).toString();
        await updateTask(task);
        if (passingTime == time && task.pomodoroCount < longBreakNumberSelect) {
          tabController.animateTo(1);
        } else {
          tabController.animateTo(2);
        }
        break;
      case 1:
        var countDown = controller.getTimeInSeconds();
        passingTime = time - countDown;
        task.breakPassingTime =
            (passingTime + int.parse(task.breakPassingTime)).toString();
        updateTask(task);
        if (passingTime == time) {
          tabController.animateTo(0);
        }
        break;
      case 2:
        var countDown = controller.getTimeInSeconds();
        passingTime = time - countDown;
        task.longBreakPassingTime =
            (passingTime + int.parse(task.longBreakPassingTime)).toString();
        updateTask(task);
        break;
      default:
    }
    notifyListeners();
  }
}
