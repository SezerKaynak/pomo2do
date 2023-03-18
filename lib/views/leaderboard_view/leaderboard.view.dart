import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';

import 'package:pomotodo/views/leaderboard_view/leaderboard.widgets.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_appbar.dart';
import 'package:provider/provider.dart';

class LeaderboardView extends StatefulWidget with LeaderboardWidgets {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  late TaskStatsProvider leaderboardProvider;

  @override
  void initState() {
    leaderboardProvider =
        Provider.of<TaskStatsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const LeaderboardAppBar(),
          FutureBuilder(
            future: leaderboardProvider.leaderboardStats(),
            builder: (context, snapshot) {
              return SliverFixedExtentList(
                itemExtent: 90.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: SizedBox(
                          height: kToolbarHeight * 1.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                (index + 4).toString(),
                              ),
                              Text(leaderboardProvider
                                  .newList[index + 3].userName!),
                              Text(
                                leaderboardProvider
                                    .newList[index + 3].taskPassingTime!
                                    .toString(),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: leaderboardProvider.newList.length - 3,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
