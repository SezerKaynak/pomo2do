import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/models/task_statistics_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  Future<void> addTask(TaskModel taskData) async {
    await _db.collection("Users/$uid/tasks").add(taskData.toMap());
  }

  Future<void> updateTask(TaskModel taskData) async {
    await _db
        .collection("Users/$uid/tasks")
        .doc(taskData.id)
        .set(taskData.toMap());
  }

  Future<void> deleteTask(String documentId) async {
    await _db.collection("Users/$uid/tasks").doc(documentId).delete();
  }

  Future<List<TaskModel>> retrieveTasks() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users/$uid/tasks").get();
    return snapshot.docs
        .map((docSnapshot) => TaskModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> updateTaskStatistics(
      TaskModel taskData, Map<String, dynamic> statistics) async {
    await _db
        .collection("Users/$uid/tasks")
        .doc(taskData.id)
        .set(statistics, SetOptions(merge: true));
  }

  Future<List<TaskStatisticsModel>> retrieveTaskStatistics(TaskModel taskData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users/$uid/tasks").get();

    return snapshot.docs
        .map((docSnapshot) => docSnapshot.data()["11-01-2023"] != null
            ? TaskStatisticsModel.fromDocumentSnapshot(
                docSnapshot.data()["11-01-2023"])
            : TaskStatisticsModel.fromDocumentSnapshot({}))
        .toList();
  }
}
