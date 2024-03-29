import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:provider/provider.dart';

class ArchivedTaskWidget extends StatefulWidget {
  const ArchivedTaskWidget({super.key});

  @override
  State<ArchivedTaskWidget> createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTaskWidget> {
  List selectedIndexes = [];
  bool buttonVisible = false;
  bool isLoading = false;
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    List<TaskModel> tasks =
        Provider.of<TasksProvider>(context, listen: false).taskLists()[3];
    var l10n = L10n.of(context)!;
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
                                    color: data.isDone == true
                                        ? Colors.green[500]
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(8.0)),
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
                                  title: Text(
                                    data.taskName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    data.taskInfo,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: const Icon(Icons.arrow_right_sharp),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                else
                  Center(child: Text(l10n.noArchiveTask)),
                if (buttonVisible)
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          int selectedNumber = selectedIndexes.length;
                          selectedIndexes.sort();
                          setState(() {
                            isLoading = true;
                          });
                          for (int i = 0; i < selectedNumber; i++) {
                            final TaskModel data = tasks[selectedIndexes[i]];

                            data.isArchive = false;
                            data.isActive = true;
                            await dbService.updateTask(data);
                          }
                          for (int i = 0; i < selectedIndexes.length; i++) {
                            tasks[selectedIndexes[i] - i].isDone
                                ? SmartDialog.showToast(
                                    "${tasks[selectedIndexes[i - i]].taskName}"
                                    " ${l10n.moveDonePage}")
                                : SmartDialog.showToast(
                                    "${tasks[selectedIndexes[i - i]].taskName}"
                                    " ${l10n.moveTaskPage}");
                            tasks.removeAt(selectedIndexes[i] - i);
                          }

                          selectedIndexes.clear();
                          buttonVisible = false;
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Text(l10n.moveArchive),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
