class LeaderboardModel {
  String? uid;
  String? userName;
  int? taskPassingTime;
  String? userPhotoUrl;

  LeaderboardModel(
      {this.uid, this.userName, this.taskPassingTime, this.userPhotoUrl});

  LeaderboardModel.fromDocumentSnapshot(Map<String, dynamic> doc)
      : uid = doc["uid"],
        userName = doc["name"],
        taskPassingTime = doc["weeklyTaskPassingTime"] ?? 0;

  // LeaderboardModel copyWith({
  //   String? userName,
  //   int? taskPassingTime,
  // }) {
  //   return LeaderboardModel(
  //     userName: userName ?? this.userName,
  //     taskPassingTime: taskPassingTime ?? this.taskPassingTime,
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'userName': userName,
  //     'taskPassingTime': taskPassingTime,
  //   };
  // }

  // factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
  //   return LeaderboardModel(
  //     userName: json['userName'] as String?,
  //     taskPassingTime: json['taskPassingTime'] as int?,
  //   );
  // }
}
