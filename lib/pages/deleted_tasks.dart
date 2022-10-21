import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:provider/provider.dart';

class DeletedTasks extends StatelessWidget {
  const DeletedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    List selectedIndexes = [];
    List<TaskModel> tasks =
        ModalRoute.of(context)!.settings.arguments as List<TaskModel>;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Çöp Kutusu"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ListUpdate>(
            builder: (context, value, child) {
              return Column(
                children: [
                  if (tasks.isNotEmpty)
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
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Consumer<ListUpdate>(
                                    builder: (context, value, child) {
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        leading: Checkbox(
                                          value:
                                              selectedIndexes.contains(index),
                                          onChanged: (_) {
                                            var checkBoxWork =
                                                context.read<ListUpdate>();
                                            checkBoxWork.checkBoxWorks(
                                                selectedIndexes, index);
                                          },
                                        ),
                                        onTap: () {
                                          var checkBoxWork =
                                              context.read<ListUpdate>();
                                          checkBoxWork.checkBoxWorks(
                                              selectedIndexes, index);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        title: Text(data.taskName),
                                        subtitle: Text(data.taskInfo),
                                        trailing:
                                            const Icon(Icons.arrow_right_sharp),
                                      );
                                    },
                                  )),
                            ],
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                        child: Text("Çöp kutusunda görev bulunamadı!")),
                  if (selectedIndexes.isNotEmpty)
                    // ignore: dead_code
                    Expanded(
                      flex: 0,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      var elevatedButtonWorks =
                                          context.read<ListUpdate>();
                                      elevatedButtonWorks.elevatedButtonWorks(
                                          selectedIndexes, tasks);
                                    },
                                    child: const Text(
                                        "Seçili görevleri tekrar aktif et")),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      var elevatedButtonWorks =
                                          context.read<ListUpdate>();
                                      elevatedButtonWorks.elevatedButtonWorks(
                                          selectedIndexes, tasks);
                                    },
                                    child: const Text(
                                        "Seçili görevleri tekrar aktif et")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              );
            },
          )),
    );
  }
}

class ListUpdate extends ChangeNotifier {
  void checkBoxWorks(List selectedIndexes, int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
    notifyListeners();
  }

  void elevatedButtonWorks(List selectedIndexes, List<TaskModel> tasks) {
    int selectedNumber = selectedIndexes.length;
    for (int i = 0; i < selectedNumber; i++) {
      final TaskModel data = tasks[selectedIndexes[i]];

      CollectionReference users = FirebaseFirestore.instance
          .collection('Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
      var task = users.doc(data.id);
      task.set({
        "taskName": data.taskName,
        "taskInfo": data.taskInfo,
        "taskType": data.taskType,
        "taskNameCaseInsensitive": data.taskName.toLowerCase(),
        "isDone": false,
        "isActive": true,
      });
    }

    for (int i = 0; i < selectedIndexes.length; i++) {
      tasks.removeAt(selectedIndexes[i] - i);
    }
    selectedIndexes.clear();
    notifyListeners();
  }
}
