import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomotodo/core/models/active_days_model.dart';
import 'package:pomotodo/core/models/sum_of_task_time_model.dart';
import 'package:pomotodo/core/models/task_by_task_model.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/models/task_statistics_model.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const Color _kLightGrey = Color.fromRGBO(238, 238, 238, 1);
const Color _kLightGreen = Color.fromRGBO(198, 228, 139, 1);
const Color _kMidGreen = Color.fromRGBO(123, 201, 111, 1);
const Color _kDarkGreen = Color.fromRGBO(35, 154, 59, 1);
const Color _kDarkerGreen = Color.fromRGBO(25, 97, 39, 1);

class TaskStatsProvider extends ChangeNotifier {
  DatabaseService service = DatabaseService();
  List<TaskStatisticsModel>? stats;
  int totalTaskTime = 0;
  List<TaskStatisticsModel>? dayStats;
  List<TaskModel>? dayTasks;
  List<TaskByTaskModel> table2 = [];
  List<SumOfTaskTimeModel> table1 = [];
  List<ActiveDaysModel> table3 = [];
  ValueNotifier<int> count = ValueNotifier<int>(6);
  List<TaskModel> tasks = [];
  int counter = 0;


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

  Future<void> getTasks() async {
    var stats = await service.retrieveTasks();
    tasks = stats;
    counter +=1;
  }

  sumOfTaskTimeMontly(DateTime date) {
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
    ActiveDaysModel monthCell = ActiveDaysModel(formattedDate, totalTime);
    table3.add(monthCell);
  }

  Future<void> sumOfTaskTime() async {
    List<String> date = getWeekDays()[0];
    DateTime now = getWeekDays()[1];
    table1.clear();
    List<String> dayOfWeeks = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

    for (var i = 6; i >= 0; i--) {
      stats = await service.retrieveTaskStatistics(date[i]);
      int totalTime = 0;
      for (var element in stats!) {
        totalTime += int.parse(element.taskPassingTime);
      }
      SumOfTaskTimeModel newColumn =
          SumOfTaskTimeModel(dayOfWeeks[(now.weekday - 1 - i) % 7], totalTime);
      table1.add(newColumn);
    }
  }

  Future<void> taskByTaskStat() async {
    List<String> date = getWeekDays()[0];
    table2.clear();
    dayTasks = await service.retrieveTasks();

    dayStats = await service.retrieveTaskStatistics(date[-count.value + 6]);

    for (var i = 0; i < dayTasks!.length; i++) {
      TaskByTaskModel deneme = TaskByTaskModel(
          dayTasks![i].taskName, int.parse(dayStats![i].taskPassingTime));
      table2.add(deneme);
    }
  }

  Widget monthCellBuilder(BuildContext buildContext, MonthCellDetails details) {
    sumOfTaskTimeMontly(details.date);
    print(table3.length);
    final Color backgroundColor =
        _getMonthCellBackgroundColor(table3[table3.length - 1].time);
    print("counter: $counter");
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

  Color _getMonthCellBackgroundColor(int time) {
    if (time > 100) {
      return _kDarkerGreen;
    } else if (time > 75) {
      return _kMidGreen;
    } else if (time > 50) {
      return _kDarkGreen;
    } else if (time > 25) {
      return _kLightGreen;
    } else {
      return _kLightGrey;
    }
  }

  Color _getCellTextColor(Color backgroundColor) {
    if (backgroundColor == _kDarkGreen || backgroundColor == _kDarkerGreen) {
      return Colors.white;
    }

    return Colors.black;
  }

  Future<void> sumOfTaskTimeWeekly() async {
    List<String> date = getWeekDays()[0];
    int totalTime = 0;

    stats = await service.retrieveTaskStatistics(date[0]);

    for (var element in stats!) {
      totalTime += int.parse(element.taskPassingTime);
    }

    totalTaskTime = totalTime;
  }
}
