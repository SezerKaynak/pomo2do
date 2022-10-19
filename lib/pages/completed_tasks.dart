import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';


class CompletedTasks extends StatefulWidget {
  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  
  @override
  Widget build(BuildContext context) {
    List<TaskModel> tasks =
        ModalRoute.of(context)!.settings.arguments as List<TaskModel>;
    return Scaffold(
      appBar: AppBar(
        title: Text(tasks.length.toString()),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final TaskModel data = tasks[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const Icon(Icons.numbers),
                    onTap: () async {
                          CollectionReference users = FirebaseFirestore.instance
                              .collection(
                                  'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
                          var task = users.doc(data.id);
                          task.set({
                            "taskName" : data.taskName,
                            "taskInfo" : data.taskInfo,
                            "taskType" : data.taskType,
                            "taskNameCaseInsensitive" : data.taskName.toLowerCase(),
                            "isDone": false,
                          });
                          tasks.removeAt(index);
                          setState(() {});
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
        },
      ),
    );
  }
}

