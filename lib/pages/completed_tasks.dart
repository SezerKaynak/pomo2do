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
  List selectedIndexes = [];
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final TaskModel data = tasks[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(16.0)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: Checkbox(
                            value: selectedIndexes.contains(index),
                            onChanged: (_) {
                              setState(() {
                                if (selectedIndexes.contains(index)) {
                                  selectedIndexes.remove(index);
                                } else {
                                  selectedIndexes.add(index);
                                }
                              });
                            },
                          ),
                          onTap: () async {
                            setState(() {
                              if (selectedIndexes.contains(index)) {
                                selectedIndexes.remove(index);
                              } else {
                                selectedIndexes.add(index);
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: Text(data.taskName),
                          subtitle: Text(data.taskInfo),
                          trailing: const Icon(Icons.arrow_right_sharp),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 0,
              child: SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      for (int i = 0; i < selectedIndexes.length; i++) {
                        final TaskModel data = tasks[selectedIndexes[i]];
                        CollectionReference users = FirebaseFirestore.instance
                            .collection(
                                'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
                        var task = users.doc(data.id);
                        task.set({
                          "taskName": data.taskName,
                          "taskInfo": data.taskInfo,
                          "taskType": data.taskType,
                          "taskNameCaseInsensitive":
                              data.taskName.toLowerCase(),
                          "isDone": false,
                        });
                      }
                      tasks.removeRange(0, selectedIndexes.length);
                      setState(() {});
                    },
                    child: const Text(
                        "Seçili görevleri tamamlanmamış olarak işaretle")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
