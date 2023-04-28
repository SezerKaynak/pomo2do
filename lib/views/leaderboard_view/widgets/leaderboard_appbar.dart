import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_widget.dart';
import 'package:provider/provider.dart';

class LeaderboardAppBar extends StatefulWidget {
  const LeaderboardAppBar({super.key});

  @override
  State<LeaderboardAppBar> createState() => _LeaderboardAppBarState();
}

class _LeaderboardAppBarState extends State<LeaderboardAppBar> {
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
      title: Text(
        L10n.of(context)!.leaderboard,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      expandedHeight: MediaQuery.of(context).size.height / 1.75,
      elevation: 0.0,
      pinned: true,
      floating: false,
      snap: false,
      flexibleSpace: const FlexibleSpaceBar(
        background: LeaderboardWidget(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
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
