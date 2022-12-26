import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/core/models/task_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel taskData) async {
    await _db
        .collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks")
        .add(taskData.toMap());
  }

  Future<void> updateTask(TaskModel taskData) async {
    await _db
        .collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks")
        .doc(taskData.id)
        .set(taskData.toMap());
  }

  Future<void> deleteTask(String documentId) async {
    await _db
        .collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks")
        .doc(documentId)
        .delete();
  }

  Future<List<TaskModel>> retrieveTasks() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks")
        .get();
    return snapshot.docs
        .map((docSnapshot) => TaskModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
