import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String taskInfo;
  final String taskName;
  final String taskType;
  final bool isDone;
  final bool isActive;
  final bool isArchive;
  final String taskPassingTime;
  final String breakPassingTime;
  TaskModel(
      {this.id,
      this.isArchive = false,
      this.isDone = false,
      this.isActive = true,
      this.taskInfo = "",
      this.taskName = "",
      this.taskType = "",
      this.taskPassingTime = "0.00",
      this.breakPassingTime = "0.00"});

  Map<String, dynamic> toMap() {
    return {
      'taskInfo': taskInfo,
      'taskName': taskName,
      'taskType': taskType,
      'isDone': isDone,
      'isActive': isActive,
      'isArchive': isArchive,
      'taskPassingTime': taskPassingTime,
      'breakPassingTime' : breakPassingTime
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
        taskPassingTime = doc.data()?["taskPassingTime"] ?? "0.00",
        breakPassingTime = doc.data()?["breakPassingTime"] ?? "0.00";

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
          breakPassingTime: dataMap['breakPassingTime']);
    }).toList();
  }
}
