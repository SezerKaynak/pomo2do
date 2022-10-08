import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? taskInfo;
  final String? taskName;
  final String? taskType;

  DataModel({this.taskInfo, this.taskName, this.taskType});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
          taskInfo: dataMap['taskInfo'],
          taskName: dataMap['taskName'],
          taskType: dataMap['taskType']);
    }).toList();
  }
}
