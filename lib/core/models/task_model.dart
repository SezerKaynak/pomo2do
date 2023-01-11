import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String taskInfo,
      taskName,
      taskType,
      taskPassingTime,
      breakPassingTime,
      longBreakPassingTime;

  int pomodoroCount, taskIcon;
  bool isDone, isActive, isArchive;

  Map<String, dynamic>? taskStatistics;

  TaskModel(
      {this.id,
      this.isArchive = false,
      this.isDone = false,
      this.isActive = true,
      this.taskInfo = "",
      this.taskName = "",
      this.taskType = "",
      this.taskPassingTime = "0",
      this.breakPassingTime = "0",
      this.longBreakPassingTime = "0",
      this.pomodoroCount = 0,
      this.taskIcon = 984386,
      this.taskStatistics});

  Map<String, dynamic> toMap() {
    return {
      'taskInfo': taskInfo,
      'taskNameCaseInsensitive': taskName.toLowerCase(),
      'taskName': taskName,
      'taskType': taskType,
      'isDone': isDone,
      'isActive': isActive,
      'isArchive': isArchive,
      'taskPassingTime': taskPassingTime,
      'breakPassingTime': breakPassingTime,
      'longBreakPassingTime': longBreakPassingTime,
      'pomodoroCount': pomodoroCount,
      'taskIcon': taskIcon,
      'taskStatistics': taskStatistics
    };
  }

  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        taskInfo = doc.data()!["taskInfo"],
        taskName = doc.data()!["taskName"],
        taskType = doc.data()!["taskType"],
        isArchive = doc.data()!["isArchive"] ?? false,
        isDone = doc.data()!["isDone"],
        isActive = doc.data()?["isActive"] ?? true,
        taskPassingTime = doc.data()?["taskPassingTime"] ?? "0",
        breakPassingTime = doc.data()?["breakPassingTime"] ?? "0",
        longBreakPassingTime = doc.data()?["longBreakPassingTime"] ?? "0",
        pomodoroCount = doc.data()?["pomodoroCount"] ?? 0,
        taskIcon = doc.data()?["taskIcon"] ?? 984386,
        taskStatistics = doc.data()?["09-01-2023"] 
        ??
            {
              "09-01-2023": {
                "taskPassingTime": "0",
                "breakPassingTime": "0",
                "longBreakPassingTime": "0"
              }
            }
            ;

  List<TaskModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return TaskModel(
          taskInfo: dataMap['taskInfo'],
          taskName: dataMap['taskName'],
          taskType: dataMap['taskType'],
          isArchive: dataMap['isArchive'],
          isDone: dataMap['isDone'],
          isActive: dataMap['isActive'],
          taskPassingTime: dataMap['taskPassingTime'],
          breakPassingTime: dataMap['breakPassingTime'],
          longBreakPassingTime: dataMap['longBreakPassingTime'],
          pomodoroCount: dataMap['pomodoroCount'],
          taskIcon: dataMap['taskIcon']);
    }).toList();
  }
}
