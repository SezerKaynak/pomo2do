import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String taskInfo;
  String taskName;
  String taskType;
  bool isDone;
  bool isActive;
  bool isArchive;
  String taskPassingTime;
  String breakPassingTime;
  String longBreakPassingTime;
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
      this.longBreakPassingTime = "0"});

  Map<String, dynamic> toMap() {
    return {
      'taskInfo': taskInfo,
      'taskName': taskName,
      'taskType': taskType,
      'isDone': isDone,
      'isActive': isActive,
      'isArchive': isArchive,
      'taskPassingTime': taskPassingTime,
      'breakPassingTime': breakPassingTime,
      'longBreakPassingTime': longBreakPassingTime
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
        longBreakPassingTime = doc.data()?["longBreakPassingTime"] ?? "0";

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
          longBreakPassingTime: dataMap['longBreakPassingTime']);
    }).toList();
  }
}
