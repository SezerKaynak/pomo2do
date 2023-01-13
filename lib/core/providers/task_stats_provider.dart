import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomotodo/core/models/sum_of_task_time_model.dart';
import 'package:pomotodo/core/models/task_by_task_model.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/models/task_statistics_model.dart';
import 'package:pomotodo/core/service/database_service.dart';

class TaskStatsProvider extends ChangeNotifier {
  DatabaseService service = DatabaseService();
  List<TaskStatisticsModel>? stats;
  int totalTaskTime = 0;
  List<TaskStatisticsModel>? dayStats;
  List<TaskModel>? dayTasks;
  List<TaskByTaskModel> table2 = [];
  List<SumOfTaskTimeModel> table1 = [];
  ValueNotifier<int> count = ValueNotifier<int>(6);

  List<dynamic> getTime() {
    List<String> dates = [];
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("dd-MM-yyyy");

    for (var i = 0; i < 7; i++) {
      DateTime previousDay = now.subtract(Duration(days: i));
      String formattedDate = formatter.format(previousDay);
      dates.add(formattedDate);
    }
    return [dates, now];
  }

  Future<void> sumOfTaskTime() async {
    List<String> date = getTime()[0];
    DateTime now = getTime()[1];
    table1.clear();
    List<String> dayOfWeeks = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

    for (var i = 6; i >= 0; i--) {
      stats = await service.retrieveTaskStatistics(date[i]);
      int totalTaskTime = 0;
      for (var element in stats!) {
        totalTaskTime += int.parse(element.taskPassingTime);
      }
      SumOfTaskTimeModel newColumn = SumOfTaskTimeModel(
          dayOfWeeks[(now.weekday - 1 - i) % 7], totalTaskTime);
      table1.add(newColumn);
    }
  }

  Future<void> taskByTaskStat() async {
    List<String> date = getTime()[0];
    table2.clear();
    dayTasks = await service.retrieveTasks();

    dayStats = await service.retrieveTaskStatistics(date[-count.value + 6]);

    for (var i = 0; i < dayTasks!.length; i++) {
      TaskByTaskModel deneme = TaskByTaskModel(
          dayTasks![i].taskName, int.parse(dayStats![i].taskPassingTime));
      table2.add(deneme);
    }
  }

  Future<void> sumOfTaskTimeWeekly() async {
    List<String> date = getTime()[0];
    int totalTime = 0;

    stats = await service.retrieveTaskStatistics(date[0]);

    for (var element in stats!) {
      totalTime += int.parse(element.taskPassingTime);
    }

    totalTaskTime = totalTime;
  }
}
