import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/locale_provider.dart';
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
    var languagePreference =
        context.read<LocaleModel>().locale == const Locale('tr', 'TR');
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
              future: providerOfTaskStat.dailyTaskPassingTime(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      languagePreference
                          ? Text(
                              '${(providerOfTaskStat.totalTaskTime / 60).floor()}:${(providerOfTaskStat.totalTaskTime % 60 < 10 ? "0${providerOfTaskStat.totalTaskTime % 60}" : providerOfTaskStat.totalTaskTime % 60)}d',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            )
                          : Text(
                              '${(providerOfTaskStat.totalTaskTime / 60).floor()}:${(providerOfTaskStat.totalTaskTime % 60 < 10 ? "0${providerOfTaskStat.totalTaskTime % 60}" : providerOfTaskStat.totalTaskTime % 60)}m',
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
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: providerOfTaskStat.leaderboardListProvider(0),
              builder: (context, snapshot) {
                int placement = providerOfTaskStat.leaderboardList.indexWhere(
                        (element) =>
                            element.uid ==
                            context.read<PomotodoUser>().userId) +
                    1;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        L10n.of(context)!.onWeeklyPlacement,
                        style:
                            TextStyle(fontSize: languagePreference ? 10 : 13),
                      ),
                    ),
                    Text(
                      languagePreference
                          ? "${placement.toString()}."
                          : placement.toString(),
                      style: const TextStyle(fontSize: 17),
                    ),
                    languagePreference
                        ? const Flexible(
                            child: Text(
                              "sıradasınız",
                              style: TextStyle(fontSize: 10),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
