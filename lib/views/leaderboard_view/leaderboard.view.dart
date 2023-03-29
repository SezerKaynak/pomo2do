import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/leaderboard_provider.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/views/leaderboard_view/leaderboard.widgets.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_appbar.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_images.dart';
import 'package:provider/provider.dart';

class LeaderboardView extends StatefulWidget with LeaderboardWidgets {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  late TaskStatsProvider leaderboardProvider;
  late LeaderboardProvider tabProvider;

  @override
  void initState() {
    leaderboardProvider =
        Provider.of<TaskStatsProvider>(context, listen: false);
    tabProvider = Provider.of<LeaderboardProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        cacheExtent: 9999,
        slivers: <Widget>[
          const LeaderboardAppBar(),
          ValueListenableBuilder(
            valueListenable: tabProvider.count,
            builder: (context, value, child) {
              return FutureBuilder(
                future: leaderboardProvider
                    .leaderboardListProvider(tabProvider.count.value),
                builder: (context, snapshot) {
                  return SliverFixedExtentList(
                    itemExtent: 90.0,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Center(
                                    child: Text(
                                      (index + 4).toString(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: LeaderboardImages(
                                      user: leaderboardProvider
                                          .leaderboardList[index + 3]),
                                ),
                                tabProvider.count.value == 0
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${leaderboardProvider.leaderboardList[index + 3].userName!} ${leaderboardProvider.leaderboardList[index + 3].surname!}"),
                                          Text(
                                            leaderboardProvider
                                                .leaderboardList[index + 3]
                                                .weeklyTaskPassingTime!
                                                .toString(),
                                          )
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${leaderboardProvider.leaderboardList[index + 3].userName!} ${leaderboardProvider.leaderboardList[index + 3].surname!}"),
                                          Text(
                                            leaderboardProvider
                                                .leaderboardList[index + 3]
                                                .montlyTaskPassingTime!
                                                .toString(),
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount:
                          leaderboardProvider.leaderboardList.length - 3,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
