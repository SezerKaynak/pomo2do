import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/clippers.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/custom_clip_path.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_images.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_widget.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/weekly_tab.dart';
import 'package:provider/provider.dart';

class WeeklyTabAppBar extends StatefulWidget {
  const WeeklyTabAppBar({super.key});

  @override
  State<WeeklyTabAppBar> createState() => _WeeklyTabAppBarState();
}

class _WeeklyTabAppBarState extends State<WeeklyTabAppBar> {
  late TaskStatsProvider leaderboardProvider;

  @override
  void initState() {
    leaderboardProvider =
        Provider.of<TaskStatsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text(
        "Liderlik Sıralaması",
      ),
      //automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      expandedHeight: MediaQuery.of(context).size.height / 1.8,
      elevation: 0.0,
      pinned: true,
      floating: false,
      snap: false,
      flexibleSpace: const FlexibleSpaceBar(
        background: LeaderboardWidget(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          child: Container(
            width: 40.0,
            height: 5.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}
