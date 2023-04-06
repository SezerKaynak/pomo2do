import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/leaderboard_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/montly_tab.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/weekly_tab.dart';
import 'package:provider/provider.dart';

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({super.key});

  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LeaderboardProvider tabProvider;

  @override
  void initState() {
    tabProvider = Provider.of<LeaderboardProvider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 50.0,
              right: 50.0,
              top: MediaQuery.of(context).size.height / 9),
          child: Container(
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              padding: const EdgeInsets.all(3),
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.green,
              ),
              onTap: (value) {
                tabProvider.count.value = _tabController.index;
              },
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs:  [
                Tab(
                  text: L10n.of(context)!.weekly,
                ),
                Tab(
                  text: L10n.of(context)!.monthly,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              WeeklyTab(),
              MontlyTab(),
            ],
          ),
        )
      ],
    );
  }
}
