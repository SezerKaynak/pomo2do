import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String taskInfo;
  final String taskName;
  final String taskType;
  final bool isDone;

  TaskModel(
      {this.id, this.isDone = false,
      required this.taskInfo,
      required this.taskName,
      required this.taskType});

  Map<String, dynamic> toMap() {
    return {
      'taskInfo': taskInfo,
      'taskName': taskName,
      'taskType': taskType,
      'isDone': isDone
    };
  }

  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        taskInfo = doc.data()!["taskInfo"],
        taskName = doc.data()!["taskName"],
        taskType = doc.data()!["taskType"],
        isDone = doc.data()!["isDone"];
}
