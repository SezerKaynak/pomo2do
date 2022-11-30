import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/service/database_service.dart';

class ArchivedTasks extends StatefulWidget {
  const ArchivedTasks({super.key});

  @override
  State<ArchivedTasks> createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTasks> {
  List selectedIndexes = [];
  bool buttonVisible = false;
  bool isLoading = false;
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    List<TaskModel> tasks =
        ModalRoute.of(context)!.settings.arguments as List<TaskModel>;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arşivlenmiş Görevler"),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
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
                                      color: data.isDone == true
                                          ? Colors.green[100]
                                          : Colors.blueGrey[50],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: Checkbox(
                                      value: selectedIndexes.contains(index),
                                      onChanged: (_) {
                                        setState(() {
                                          if (selectedIndexes.contains(index)) {
                                            selectedIndexes.remove(index);
                                            buttonVisible = false;
                                          } else {
                                            selectedIndexes.add(index);
                                            buttonVisible = true;
                                          }
                                        });
                                      },
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        if (selectedIndexes.contains(index)) {
                                          selectedIndexes.remove(index);
                                          buttonVisible = false;
                                        } else {
                                          selectedIndexes.add(index);
                                          buttonVisible = true;
                                        }
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    title: Text(data.taskName),
                                    subtitle: Text(data.taskInfo),
                                    trailing:
                                        const Icon(Icons.arrow_right_sharp),
                                  ),
                                ),
                              ],
                            );
                          }),
                    )
                  else
                    const Center(child: Text("Arşivlenmiş görev bulunamadı!")),
                  if (buttonVisible)
                    Expanded(
                      flex: 0,
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

                                data.isArchive = false;
                                data.isActive = true;
                                await dbService.updateTask(data);
                              }
                              for (int i = 0; i < selectedIndexes.length; i++) {
                                tasks.removeAt(selectedIndexes[i] - i);
                              }
                              selectedIndexes.clear();
                              buttonVisible = false;
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child:
                                const Text("Seçili görevleri arşivden çıkar")),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
