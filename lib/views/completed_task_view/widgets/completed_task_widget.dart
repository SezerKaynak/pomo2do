import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:provider/provider.dart';

class CompletedTasksWidget extends StatefulWidget {
  const CompletedTasksWidget({super.key});

  @override
  State<CompletedTasksWidget> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasksWidget> {
  List selectedIndexes = [];
  bool isLoading = false;
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    List<TaskModel> tasks = Provider.of<TasksProvider>(context).taskLists()[0];

    return Column(
      children: [
        SizedBox(
          height: 2,
          child: Align(
            alignment: Alignment.topCenter,
            child: Visibility(
                visible: isLoading,
                child: const LinearProgressIndicator(color: Colors.red)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                                  color: Colors.green[500],
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
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InkWell(
                                        child: const Icon(Icons.archive),
                                        onTap: () async {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          data.isDone = true;
                                          data.isActive = true;
                                          data.isArchive = true;
                                          await dbService.updateTask(data);

                                          setState(() {
                                            tasks.removeAt(index);
                                            selectedIndexes.clear();
                                            isLoading = false;
                                          });
                                          SmartDialog.showToast(
                                              "Görev arşive taşındı!");
                                        }),
                                    InkWell(
                                        child: const Icon(Icons.delete),
                                        onTap: () async {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          data.isDone = true;
                                          data.isActive = false;
                                          data.isArchive = false;
                                          await dbService.updateTask(data);

                                          setState(() {
                                            tasks.removeAt(index);
                                            selectedIndexes.clear();
                                            isLoading = false;
                                          });
                                          SmartDialog.showToast(
                                              "Görev çöp kutusuna taşındı!");
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  const Center(child: Text("Tamamlanmış görev bulunamadı!")),
                if (selectedIndexes.isNotEmpty)
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 400,
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () async {
                              int selectedNumber = selectedIndexes.length;
                              selectedIndexes.sort();
                              setState(() {
                                isLoading = true;
                              });
                              for (int i = 0; i < selectedNumber; i++) {
                                final TaskModel data =
                                    tasks[selectedIndexes[i]];

                                data.isDone = false;
                                data.isActive = true;
                                await dbService.updateTask(data);
                              }
                              for (int i = 0; i < selectedIndexes.length; i++) {
                                tasks.removeAt(selectedIndexes[i] - i);
                              }
                              selectedIndexes.clear();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: const Text(
                                "Seçili görevleri tamamlanmamış olarak işaretle")),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
