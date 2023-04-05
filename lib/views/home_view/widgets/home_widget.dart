import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/core/service/google_ads.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/views/home_view/widgets/task_shimmer.dart';
import 'package:pomotodo/views/home_view/widgets/mini_task_statistics.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = L10n.of(context)!;
    final providerOfTasks = Provider.of<TasksProvider>(context, listen: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: kToolbarHeight,
            child: ChangeNotifierProvider(
                create: (context) => TaskStatsProvider(),
                child: const MiniTaskStatistics()),
          ),
        ),
        Expanded(
          flex: 12,
          child: RefreshIndicator(
            onRefresh: providerOfTasks.refresh,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FutureBuilder(
                future: providerOfTasks.getTasks(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.hasData) {
                    try {
                      return providerOfTasks.retrievedTaskList!.isEmpty
                          ? Center(child: Text(l10n.noActiveTask))
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              shrinkWrap: true,
                              itemCount:
                                  providerOfTasks.retrievedTaskList!.length + 1,
                              itemBuilder: (context, index) {
                                if (index ==
                                    providerOfTasks.retrievedTaskList!.length) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                String key = providerOfTasks
                                    .retrievedTaskList!.keys
                                    .elementAt(index);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(key,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    ListView.separated(
                                      physics: const ClampingScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 5),
                                      shrinkWrap: true,
                                      itemCount: providerOfTasks
                                          .retrievedTaskList![key]!.length,
                                      itemBuilder: (context, index) {
                                        int codePoint = providerOfTasks
                                            .retrievedTaskList![key]![index]
                                            .taskIcon;
                                        IconData taskIcon = IconData(codePoint,
                                            fontFamily: 'MaterialIcons');
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Dismissible(
                                                onDismissed:
                                                    ((direction) async {
                                                  if (direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                    providerOfTasks.dismiss(
                                                        key, index);
                                                  } else {
                                                    {
                                                      Navigator.pushNamed(
                                                          context, '/editTask',
                                                          arguments: [
                                                            key,
                                                            index
                                                          ]).then((_) =>
                                                          providerOfTasks
                                                              .refresh());
                                                    }
                                                  }
                                                }),
                                                confirmDismiss:
                                                    (DismissDirection
                                                        direction) async {
                                                  if (direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                    return await QuickAlert
                                                        .show(
                                                      context: context,
                                                      type: QuickAlertType
                                                          .confirm,
                                                      title:
                                                          l10n.trashAlertTitle,
                                                      text: l10n
                                                          .trashAlertSubtitle,
                                                      confirmBtnText:
                                                          l10n.alertApprove,
                                                      cancelBtnText:
                                                          l10n.alertReject,
                                                      confirmBtnColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .error,
                                                      onConfirmBtnTap: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      onCancelBtnTap: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                    );
                                                  }
                                                  return true;
                                                },
                                                background: Container(
                                                  color:
                                                      const Color(0xFF21B7CA),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 28.0),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons.edit,
                                                          color: Colors.white),
                                                      Text(
                                                        l10n.editText,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                secondaryBackground: Container(
                                                    color: Colors.red,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 28.0),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerEnd,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(Icons.delete,
                                                            color:
                                                                Colors.white),
                                                        Text(l10n.moveIntoTrash,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white))
                                                      ],
                                                    )),
                                                resizeDuration: const Duration(
                                                    milliseconds: 200),
                                                key: UniqueKey(),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                  leading: Icon(taskIcon),
                                                  onTap: () {
                                                    GoogleAds()
                                                        .loadInterstitialAd();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChangeNotifierProvider(
                                                                  create: (context) =>
                                                                      PageUpdate(),
                                                                  child:
                                                                      PomodoroWidget(
                                                                    task: providerOfTasks
                                                                            .retrievedTaskList![
                                                                        key]![index],
                                                                  )),
                                                        )).then((_) {
                                                      TaskStatsProvider
                                                          leaderboardUpdate =
                                                          TaskStatsProvider();
                                                      leaderboardUpdate
                                                          .weeklyTaskPassingTime();
                                                      leaderboardUpdate
                                                          .montlyTaskPassingTime();
                                                      providerOfTasks.refresh();
                                                    });
                                                  },
                                                  title: Text(
                                                    providerOfTasks
                                                        .retrievedTaskList![
                                                            key]![index]
                                                        .taskName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(providerOfTasks
                                                      .retrievedTaskList![key]![
                                                          index]
                                                      .taskInfo),
                                                  trailing: const Icon(
                                                      Icons.arrow_right_sharp),
                                                )),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                );
                              });
                    } catch (e) {
                      providerOfTasks.refresh();
                    }
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      providerOfTasks.retrievedTaskList!.isEmpty) {
                    return Center(
                      child: ListView(
                        children: const [
                          Align(
                              alignment: AlignmentDirectional.center,
                              child: Text(noTask)),
                        ],
                      ),
                    );
                  }
                  return const TaskShimmer();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
