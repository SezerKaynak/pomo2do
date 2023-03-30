import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/list_update_provider.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:provider/provider.dart';

class DeletedTasksWidget extends StatelessWidget {
  const DeletedTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List selectedIndexes = [];

    List<TaskModel> tasks = Provider.of<TasksProvider>(context).taskLists()[2];

    return Consumer<ListUpdate>(
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
                                        color: Colors.red[400],
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                                          title: Text(
                                            data.taskName,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            data.taskInfo,
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
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
                      Center(child: Text(L10n.of(context)!.noTaskTrash)),
                    if (selectedIndexes.isNotEmpty)
                      Card(
                        clipBehavior: Clip.hardEdge,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 1),
                        ),
                        child: SizedBox(
                          height: kToolbarHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Material(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8))),
                                  color: Colors.green[500],
                                  child: InkWell(
                                    onTap: () {
                                      var elevatedButtonWorks =
                                          context.read<ListUpdate>();
                                      elevatedButtonWorks.taskActivationButton(
                                          selectedIndexes, tasks);
                                    },
                                    child: SizedBox(
                                      child: Center(
                                        child: Text(
                                          L10n.of(context)!.activeButton,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
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
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8))),
                                  color: Colors.red[400],
                                  child: InkWell(
                                      onTap: () {
                                        var elevatedButtonWorks =
                                            context.read<ListUpdate>();
                                        elevatedButtonWorks.deleteTasksButton(
                                            selectedIndexes, tasks);
                                      },
                                      child:  SizedBox(
                                        child: Center(
                                            child: Text(
                                          L10n.of(context)!.deleteButton,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
