import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:provider/provider.dart';

class MiniTaskStatistics extends StatelessWidget {
  const MiniTaskStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOfTasks = Provider.of<TasksProvider>(context, listen: true);
    final providerOfTaskStat = Provider.of<TaskStatsProvider>(context);
    return Row(
      children: [
        Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(right: BorderSide(width: 0.5))),
                child: FutureBuilder(
                    future: providerOfTasks.getTasks(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TaskModel>> snapshot) {
                      if (snapshot.hasData) {
                        try {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                providerOfTasks.getLengthofMap().toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                L10n.of(context)!.taskBeCompleted,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          );
                        } catch (e) {
                          providerOfTasks.refresh();
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
                    future: providerOfTasks.getTasks(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TaskModel>> snapshot) {
                      if (snapshot.hasData) {
                        try {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                providerOfTasks
                                    .taskLists()[0]
                                    .length
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                L10n.of(context)!.doneTask,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          );
                        } catch (e) {
                          providerOfTasks.refresh();
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(width: 0.5))),
            child: FutureBuilder(
              future: providerOfTaskStat.sumOfTaskTimeWeekly(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${providerOfTaskStat.totalTaskTime}s',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        L10n.of(context)!.passingTime,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        const Expanded(
            child: Center(child: Text("0", style: TextStyle(fontSize: 20)))),
      ],
    );
  }
}
