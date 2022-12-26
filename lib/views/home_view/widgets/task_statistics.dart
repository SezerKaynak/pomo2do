import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/task_model.dart';
import 'package:flutter_application_1/core/providers/tasks_provider.dart';
import 'package:provider/provider.dart';

class TaskStatistics extends StatelessWidget {
  const TaskStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOfTasks = Provider.of<TasksProvider>(context, listen: true);
    providerOfTasks.getTasks();
    return Row(
      children: [
        Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(right: BorderSide(width: 0.5))),
                child: FutureBuilder(
                    future: providerOfTasks.taskList,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TaskModel>> snapshot) {
                      if (snapshot.hasData
                          //&& snapshot.data!.isNotEmpty
                          ) {
                        try {
                          return Center(
                              child: Text(
                            providerOfTasks.getLengthofMap().toString(),
                            style: const TextStyle(fontSize: 20),
                          ));
                        } catch (e) {
                          return const Center(
                              child: RepaintBoundary(
                                  child: CircularProgressIndicator()));
                        }
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          providerOfTasks.retrievedTaskList!.isEmpty) {
                        return const Center(
                            child: Text("0", style: TextStyle(fontSize: 20)));
                      }
                      return const Center(
                          child: RepaintBoundary(
                              child: CircularProgressIndicator()));
                    }))),
        Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(right: BorderSide(width: 0.5))),
                child: FutureBuilder(
                    future: providerOfTasks.taskList,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TaskModel>> snapshot) {
                      if (snapshot.hasData
                          //&& snapshot.data!.isNotEmpty
                          ) {
                        try {
                          return Center(
                              child: Text(
                            providerOfTasks.taskLists()[0].length.toString(),
                            style: const TextStyle(fontSize: 20),
                          ));
                        } catch (e) {
                          return const Center(
                              child: RepaintBoundary(
                                  child: CircularProgressIndicator()));
                        }
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          providerOfTasks.retrievedTaskList!.isEmpty) {
                        return const Center(
                            child: Text("0", style: TextStyle(fontSize: 20)));
                      }
                      return const Center(
                          child: RepaintBoundary(
                              child: CircularProgressIndicator()));
                    }))),
        Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(right: BorderSide(width: 0.5))),
                child: const Center(
                    child: Text("0", style: TextStyle(fontSize: 20))))),
        const Expanded(
            child: Center(child: Text("0", style: TextStyle(fontSize: 20)))),
      ],
    );
  }
}
