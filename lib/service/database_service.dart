import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/task.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addTask(TaskModel taskData) async {
    await _db
        .collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks")
        .add(taskData.toMap());
  }

  updateTask(TaskModel taskData) async{
    await _db
        .collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks").doc(taskData.id);
  }
  Future<void> deleteTask(String documentId) async{
    await _db.collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks").doc(documentId).delete();
  }

  Future<List<TaskModel>> retrieveTasks() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users/${FirebaseAuth.instance.currentUser!.uid}/tasks").get();
    return snapshot.docs
        .map((docSnapshot) => TaskModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
