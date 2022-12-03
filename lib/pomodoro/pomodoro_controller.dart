import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_application_1/service/database_service.dart';

class PageUpdate extends ChangeNotifier {
  bool skipButtonVisible = false;
  bool startStop = true;
  bool onWillPop = true;
  final String basla = "BAŞLAT";
  final String durdur = "DURDUR";
  DatabaseService dbService = DatabaseService();

  void startButton(CountDownController controller, int time) {
    controller.resume();
    skipButtonVisible = true;
    startStop = false;

    notifyListeners();
  }

  void startOrStop(int time, CountDownController controller, TaskModel task,
      TabController tabController) {
    if (startStop == true) {
      startButton(controller, time);
      onWillPop = false;
    } else {
      stop(controller, task, tabController.index, time, tabController);
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

  void stop(CountDownController controller, TaskModel task, int index, int time,
      TabController tabController) async {
    startStop = true;
    controller.pause();
    int passingTime;

    switch (index) {
      case 0:
        var countDown = controller.getTimeInSeconds();
        passingTime = time - countDown;
        task.taskPassingTime =
            (passingTime + int.parse(task.taskPassingTime)).toString();
        await dbService.updateTask(task);
        if(passingTime == time){
          tabController.animateTo(1);
        }
        break;
      case 1:
        var countDown = controller.getTimeInSeconds();
        passingTime = time - countDown;
        task.breakPassingTime =
            (passingTime + int.parse(task.breakPassingTime)).toString();
        dbService.updateTask(task);
        break;
      case 2:
        var countDown = controller.getTimeInSeconds();
        passingTime = time - countDown;
        task.longBreakPassingTime =
            (passingTime + int.parse(task.longBreakPassingTime)).toString();
        dbService.updateTask(task);
        break;
      default:
    }
    notifyListeners();
  }
}
