import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
      body: Consumer<ListUpdate>(
        builder: (context, value, child) {
          return Column(
            children: [
              SizedBox(
                height: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                      visible: context.read<ListUpdate>().isLoading,
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
                                          color: Colors.red[200],
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: Consumer<ListUpdate>(
                                        builder: (context, value, child) {
                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            leading: Checkbox(
                                              value: selectedIndexes
                                                  .contains(index),
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
                                            trailing: const Icon(
                                                Icons.arrow_right_sharp),
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
                        Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: kToolbarHeight,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Material(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomLeft:
                                                    Radius.circular(15))),
                                        color: Colors.green[500],
                                        child: InkWell(
                                          onTap: () {
                                            var elevatedButtonWorks =
                                                context.read<ListUpdate>();
                                            elevatedButtonWorks
                                                .taskActivationButton(
                                                    selectedIndexes, tasks);
                                          },
                                          child: const SizedBox(
                                            child: Center(
                                              child: Text(
                                                "Aktif Et",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Material(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15))),
                                        color: Colors.red[300],
                                        child: InkWell(
                                            onTap: () {
                                              var elevatedButtonWorks =
                                                  context.read<ListUpdate>();
                                              elevatedButtonWorks
                                                  .deleteTasksButton(
                                                      selectedIndexes, tasks);
                                            },
                                            child: const SizedBox(
                                              child: Center(
                                                  child: Text(
                                                "Sil",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        )
                    ],
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

class ListUpdate extends ChangeNotifier {
  bool isLoading = false;
  DatabaseService dbService = DatabaseService();
  void checkBoxWorks(List selectedIndexes, int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
    notifyListeners();
  }

  void taskActivationButton(List selectedIndexes, List<TaskModel> tasks) async {
    int selectedNumber = selectedIndexes.length;
    selectedIndexes.sort();
    isLoading = true;
    notifyListeners();
    for (int i = 0; i < selectedNumber; i++) {
      final TaskModel data = tasks[selectedIndexes[i]];
      data.isActive = true;
      await dbService.updateTask(data);
    }

    for (int i = 0; i < selectedIndexes.length; i++) {
      tasks[selectedIndexes[i] - i].isDone
          ? SmartDialog.showToast(
              "${tasks[selectedIndexes[i - i]].taskName} görevi tamamlanmış görevler sayfasına taşındı!")
          : SmartDialog.showToast(
              "${tasks[selectedIndexes[i - i]].taskName} görevi görevler sayfasına taşındı!");
      tasks.removeAt(selectedIndexes[i] - i);
    }
    selectedIndexes.clear();
    isLoading = false;
    notifyListeners();
  }

  void deleteTasksButton(List selectedIndexes, List<TaskModel> tasks) async {
    int selectedNumber = selectedIndexes.length;
    selectedIndexes.sort();
    for (int i = 0; i < selectedNumber; i++) {
      await dbService.deleteTask(tasks[selectedIndexes[i]].id.toString());
    }

    for (int i = 0; i < selectedIndexes.length; i++) {
      tasks.removeAt(selectedIndexes[i] - i);
    }
    selectedIndexes.clear();
    notifyListeners();
  }
}
