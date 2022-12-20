import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/providers/list_update_provider.dart';
import 'package:provider/provider.dart';

class DeletedTasks extends StatelessWidget {
  const DeletedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    List selectedIndexes = [];

    List<TaskModel> tasks = Provider.of<TasksProvider>(context).taskLists()[2];
    
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
                                          color: Colors.red[400],
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

                        Container(
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
                                  color: Colors.red[400],
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

