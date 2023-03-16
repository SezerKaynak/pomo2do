import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pomotodo/core/models/leaderboard_model.dart';
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
        .set(taskData.toMap(), SetOptions(merge: true));
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

  Future<void> updateTaskStatistics(TaskModel taskData, int passingTime,
      String startDate, int tabIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users/$uid/tasks").doc(taskData.id).get();

    TaskStatisticsModel updatedStats;
    snapshot.data()![startDate] != null
        ? updatedStats = TaskStatisticsModel.fromDocumentSnapshot(
            snapshot.data()![startDate])
        : updatedStats = TaskStatisticsModel.fromDocumentSnapshot({});

    switch (tabIndex) {
      case 0:
        updatedStats.taskPassingTime =
            (passingTime + int.parse(updatedStats.taskPassingTime)).toString();
        break;
      case 1:
        updatedStats.breakPassingTime =
            (passingTime + int.parse(updatedStats.breakPassingTime)).toString();
        break;
      case 2:
        updatedStats.longBreakPassingTime =
            (passingTime + int.parse(updatedStats.longBreakPassingTime))
                .toString();
        break;
      default:
    }

    await _db
        .collection("Users/$uid/tasks")
        .doc(taskData.id)
        .set(updatedStats.toMap(), SetOptions(merge: true));
  }

  Future<List<TaskStatisticsModel>> retrieveTaskStatistics(String date) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users/$uid/tasks").get();

    return snapshot.docs
        .map((docSnapshot) => docSnapshot.data()[date] != null
            ? TaskStatisticsModel.fromDocumentSnapshot(docSnapshot.data()[date])
            : TaskStatisticsModel.fromDocumentSnapshot({}))
        .toList();
  }

  Future<List<LeaderboardModel>> leaderboard() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").get();

    return snapshot.docs.map((docSnapshot) => LeaderboardModel(
        uid: docSnapshot.id,
        userName: docSnapshot.data()['name'],
        taskPassingTime: docSnapshot.data()["weeklyTaskPassingTime"] ?? 0)).toList();

    // QuerySnapshot<Map<String, dynamic>> snapshot =
    //     await _db.collection("Users").get();
    // return snapshot.docs
    //     .map((docSnapshot) =>
    //         LeaderboardModel.fromDocumentSnapshot(docSnapshot.data()))
    //     .toList();
  }

  Future<void> setTaskPassingTime(int weeklyTaskPassingTime) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'weeklyTaskPassingTime': weeklyTaskPassingTime}, SetOptions(merge: true));
  }
}
