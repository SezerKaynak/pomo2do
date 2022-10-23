import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String taskInfo;
  final String taskName;
  final String taskType;
  final bool isDone;
  final bool isActive;

  TaskModel(
      {this.id,
      this.isDone = false,
      this.isActive = true,
      this.taskInfo = "",
      this.taskName = "",
      this.taskType = ""});

  Map<String, dynamic> toMap() {
    return {
      'taskInfo': taskInfo,
      'taskName': taskName,
      'taskType': taskType,
      'isDone': isDone,
      'isActive': isActive
    };
  }

  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        taskInfo = doc.data()!["taskInfo"],
        taskName = doc.data()!["taskName"],
        taskType = doc.data()!["taskType"],
        isDone = doc.data()!["isDone"],
        isActive = doc.data()?["isActive"] ?? true;

  List<TaskModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return TaskModel(
          taskInfo: dataMap['taskInfo'],
          taskName: dataMap['taskName'],
          taskType: dataMap['taskType'],
          isDone: dataMap['isDone'],
          isActive: dataMap['isActive']);
    }).toList();
  }
}
