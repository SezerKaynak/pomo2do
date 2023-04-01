import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardModel {
  String? uid;
  String? userName;
  String? surname;
  int? weeklyTaskPassingTime;
  int? montlyTaskPassingTime;
  String? userPhotoUrl;

  LeaderboardModel(
      {this.uid,
      this.userName,
      this.surname,
      this.weeklyTaskPassingTime,
      this.montlyTaskPassingTime,
      this.userPhotoUrl});

  LeaderboardModel.fromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        userPhotoUrl = doc.data()['userPhotoUrl'],
        userName = doc.data()['name'],
        surname = doc.data()['surname'],
        weeklyTaskPassingTime = doc.data()["weeklyTaskPassingTime"] ?? 0,
        montlyTaskPassingTime = doc.data()["montlyTaskPassingTime"] ?? 0;
}
