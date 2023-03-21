import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/clippers.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/custom_clip_path.dart';
import 'package:pomotodo/views/leaderboard_view/widgets/leaderboard_images.dart';
import 'package:provider/provider.dart';

class WeeklyTab extends StatefulWidget {
  const WeeklyTab({super.key});

  @override
  State<WeeklyTab> createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTab> {
  late TaskStatsProvider leaderboardProvider;

  @override
  void initState() {
    leaderboardProvider =
        Provider.of<TaskStatsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: leaderboardProvider.leaderboardWeeklyStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          LeaderboardImages first = LeaderboardImages(
              user: leaderboardProvider.leaderboardWeeklyList[0]);

          LeaderboardImages second = LeaderboardImages(
              user: leaderboardProvider.leaderboardWeeklyList[1]);

          LeaderboardImages third = LeaderboardImages(
              user: leaderboardProvider.leaderboardWeeklyList[2]);
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 30.0),
                height: MediaQuery.of(context).size.height / 2.6,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              first,
                              Text(
                                leaderboardProvider
                                    .leaderboardWeeklyList[1].userName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                leaderboardProvider
                                    .leaderboardWeeklyList[1].taskPassingTime
                                    .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomClipPath(
                                clipper: FirstClipper(),
                                color: Colors.black,
                                height: 15,
                                fontSize: 40,
                              ),
                              CustomClipPath(
                                clipper: RectangleClipper(),
                                color: Colors.pink,
                                height: 100,
                                fontSize: 70,
                                text: "2",
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              const FaIcon(FontAwesomeIcons.crown,
                                  color: Color.fromARGB(255, 230, 200, 35)),
                              second,
                              Text(
                                leaderboardProvider
                                    .leaderboardWeeklyList[0].userName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                leaderboardProvider
                                    .leaderboardWeeklyList[0].taskPassingTime
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomClipPath(
                                clipper: MiddleClipper(),
                                color: Colors.black,
                                height: 15,
                                fontSize: 40,
                              ),
                              CustomClipPath(
                                clipper: RectangleClipper(),
                                color: Colors.green,
                                height: 140,
                                fontSize: 100,
                                text: '1',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              third,
                              Text(
                                leaderboardProvider
                                    .leaderboardWeeklyList[2].userName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                leaderboardProvider
                                    .leaderboardWeeklyList[2].taskPassingTime
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomClipPath(
                                clipper: LastClipper(),
                                color: Colors.black,
                                height: 15,
                                fontSize: 40,
                              ),
                              CustomClipPath(
                                clipper: RectangleClipper(),
                                color: Colors.orange,
                                fontSize: 40,
                                height: 60,
                                text: '3',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2.4,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
