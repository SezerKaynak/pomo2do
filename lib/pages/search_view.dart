import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/pomodoro.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      pressed: () {
        Navigator.pop(context);
      },
      firestoreCollectionName:
          'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks',
      searchBy: 'taskNameCaseInsensitive',
      dataListFromSnapshot: TaskModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TaskModel>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('Sonuç Bulunamadı!'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final TaskModel data = dataList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(16.0)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: const Icon(Icons.numbers),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PomodoroView(task: dataList[index],)));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: Text(data.taskName),
                          subtitle: Text(data.taskInfo),
                          trailing: const Icon(Icons.arrow_right_sharp),
                        ),
                      ),
                    ),
                  ],
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Sonuç Bulunamadı!'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
