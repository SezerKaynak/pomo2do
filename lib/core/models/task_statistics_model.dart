import 'package:intl/intl.dart';

class TaskStatisticsModel {
  String taskPassingTime, breakPassingTime, longBreakPassingTime;

  TaskStatisticsModel({
    this.taskPassingTime = "0",
    this.breakPassingTime = "0",
    this.longBreakPassingTime = "0",
  });

  Map<String, dynamic> toMap() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("dd-MM-yyyy");
    final String formattedDate = formatter.format(now);

    return {
      formattedDate: {
        "taskPassingTime": taskPassingTime,
        "breakPassingTime": breakPassingTime,
        "longBreakPassingTime": longBreakPassingTime
      },
    };
  }

  TaskStatisticsModel.fromDocumentSnapshot(Map<String, dynamic> doc)
      : taskPassingTime = doc["taskPassingTime"] ?? "0",
        breakPassingTime = doc["breakPassingTime"] ?? "0",
        longBreakPassingTime = doc["longBreakPassingTime"] ?? "0";
}
