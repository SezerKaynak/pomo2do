import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String taskInfo;
  final String taskName;
  final String taskType;
  final bool isDone;
  final bool isActive;

  TaskModel( 
      {this.id, this.isDone = false,
      this.isActive = true,
      required this.taskInfo,
      required this.taskName,
      required this.taskType});

  Map<String, dynamic> toMap() {
    return {
      'taskInfo': taskInfo,
      'taskName': taskName,
      'taskType': taskType,
      'isDone': isDone,
      'isActive' : isActive
    };
  }

  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        taskInfo = doc.data()!["taskInfo"],
        taskName = doc.data()!["taskName"],
        taskType = doc.data()!["taskType"],
        isDone = doc.data()!["isDone"],
        isActive = doc.data()?["isActive"] ?? true;
}
