import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomotodo/core/models/active_days_model.dart';
import 'package:pomotodo/core/models/leaderboard_model.dart';
import 'package:pomotodo/core/models/sum_of_task_time_model.dart';
import 'package:pomotodo/core/models/task_by_task_model.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/models/task_statistics_model.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:pomotodo/utils/constants/constants.dart';

class TaskStatsProvider extends ChangeNotifier {
  DatabaseService service = DatabaseService();
  List<LeaderboardModel> leaderboardList = [];
  List<TaskStatisticsModel>? stats;
  int totalTaskTime = 0;
  List<TaskByTaskModel> table2 = [];
  List<SumOfTaskTimeModel> table1 = [];
  List<ActiveDaysModel> table3 = [];
  ValueNotifier<int> count = ValueNotifier<int>(6);
  List<TaskModel> tasks = [];

  List<dynamic> getWeekDays() {
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

  List<dynamic> getMonthDays() {
    List<String> dates = [];
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("dd-MM-yyyy");

    for (var i = 0; i < 30; i++) {
      DateTime previousDay = now.subtract(Duration(days: i));
      String formattedDate = formatter.format(previousDay);
      dates.add(formattedDate);
    }
    return [dates, now];
  }

  Future<void> getTasks() async {
    tasks = await service.retrieveTasks();
    sumOfTaskTime();
  }

  sumOfTaskTimeMontly(DateTime date) {
    List<ActiveDaysModel> cell = [];
    final DateFormat formatter = DateFormat("dd-MM-yyyy");
    final String formattedDate = formatter.format(date);
    int totalTime = 0;
    for (var j = 0; j < tasks.length; j++) {
      var deneme = tasks[j].taskStatistics![formattedDate];
      var ikinciDeneme = deneme != null
          ? TaskStatisticsModel.fromDocumentSnapshot(deneme)
          : TaskStatisticsModel.fromDocumentSnapshot({});
      totalTime += int.parse(ikinciDeneme.taskPassingTime);
    }
    ActiveDaysModel monthCell = ActiveDaysModel(formattedDate, totalTime/60);
    cell.add(monthCell);
    table3 = cell;
  }

  taskToTaskStats(String date) {
    List<TaskStatisticsModel> stats = [];

    for (var i = 0; i < tasks.length; i++) {
      var task = tasks[i].taskStatistics![date];
      task != null
          ? stats.add(TaskStatisticsModel.fromDocumentSnapshot(task))
          : stats.add(TaskStatisticsModel.fromDocumentSnapshot({}));
    }
    return stats;
  }

  sumOfTaskTime() {
    List<String> date = getWeekDays()[0];
    DateTime now = getWeekDays()[1];
    table1.clear();
    List<String> dayOfWeeks = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

    for (var i = 6; i >= 0; i--) {
      List<TaskStatisticsModel> stats = taskToTaskStats(date[i]);

      double totalTime = 0;
      for (var element in stats) {
        totalTime += int.parse(element.taskPassingTime)/60;
      }
      SumOfTaskTimeModel newColumn =
          SumOfTaskTimeModel(dayOfWeeks[(now.weekday - 1 - i) % 7], totalTime);
      table1.add(newColumn);
    }
  }

  Future<void> taskByTaskStat() async {
    List<String> date = getWeekDays()[0];
    List<TaskByTaskModel> taskByTask = [];
    List<TaskStatisticsModel> dayStats =
        taskToTaskStats(date[-count.value + 6]);

    for (var i = 0; i < tasks.length; i++) {
      TaskByTaskModel task = TaskByTaskModel(
          tasks[i].taskName, double.parse(dayStats[i].taskPassingTime)/60);
      if (task.passingTime != 0) taskByTask.add(task);
    }
    table2 = taskByTask;
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    sumOfTaskTimeMontly(details.date);
    final Color backgroundColor =
        _getMonthCellBackgroundColor(table3[table3.length - 1].time);
    const Color defaultColor = Colors.white;
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: defaultColor, width: 0.5)),
      child: Center(
        child: Text(
          details.date.day.toString(),
          style: TextStyle(color: _getCellTextColor(backgroundColor)),
        ),
      ),
    );
  }

  Color _getMonthCellBackgroundColor(double time) {
    if (time > 120) {
      return kDarkerGreen;
    } else if (time > 80) {
      return kDarkGreen;
    } else if (time > 40) {
      return kMidGreen;
    } else if (time > 0) {
      return kLightGreen;
    } else {
      return kLightGrey;
    }
  }

  Color _getCellTextColor(Color backgroundColor) {
    if (backgroundColor == kDarkGreen || backgroundColor == kDarkerGreen) {
      return Colors.white;
    }

    return Colors.black;
  }

  Future<void> dailyTaskPassingTime() async {
    List<String> date = getWeekDays()[0];
    int totalTime = 0;

    stats = await service.retrieveTaskStatistics(date[0]);

    for (var element in stats!) {
      totalTime += int.parse(element.taskPassingTime);
    }

    totalTaskTime = totalTime;
  }

  Future<void> leaderboardListProvider(int index) async {
    leaderboardList = await service.leaderboardStats();
    switch (index) {
      case 0:
        leaderboardList.sort(
          (a, b) =>
              b.weeklyTaskPassingTime!.compareTo(a.weeklyTaskPassingTime!),
        );
        break;
      case 1:
        leaderboardList.sort(
          (a, b) =>
              b.montlyTaskPassingTime!.compareTo(a.montlyTaskPassingTime!),
        );
        break;
      default:
    }
  }

  void weeklyTaskPassingTime() async {
    tasks = await service.retrieveTasks();
    List<String> date = getWeekDays()[0];
    int weeklyTaskPassingTime = 0;

    for (var i = 0; i < date.length; i++) {
      List<TaskStatisticsModel> stats = taskToTaskStats(date[i]);

      for (var element in stats) {
        weeklyTaskPassingTime += int.parse(element.taskPassingTime);
      }
    }
    service.setWeeklyTaskPassingTime(weeklyTaskPassingTime);
  }

  void montlyTaskPassingTime() async {
    tasks = await service.retrieveTasks();
    List<String> date = getMonthDays()[0];
    int montlyTaskPassingTime = 0;

    for (var i = 0; i < date.length; i++) {
      List<TaskStatisticsModel> stats = taskToTaskStats(date[i]);

      for (var element in stats) {
        montlyTaskPassingTime += int.parse(element.taskPassingTime);
      }
    }
    service.setMontlyTaskPassingTime(montlyTaskPassingTime);
  }
}
