import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/drawer_image_provider.dart';
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
    return Column(
      children: [
        FutureBuilder(
          future: leaderboardProvider.leaderboardStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Consumer<DrawerImageProvider>(
                                  builder: (context, value, child) {
                                    return LeaderboardImages(
                                        uid: leaderboardProvider
                                            .newList[1].uid!);
                                  },
                                ),
                                Text(leaderboardProvider.newList[1].userName!),
                                Text(
                                  leaderboardProvider.newList[1].taskPassingTime
                                      .toString(),
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
                                LeaderboardImages(
                                    uid: leaderboardProvider.newList[0].uid!),
                                Text(leaderboardProvider.newList[0].userName!),
                                Text(
                                  leaderboardProvider.newList[0].taskPassingTime
                                      .toString(),
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
                                LeaderboardImages(
                                    uid: leaderboardProvider.newList[2].uid!),
                                Text(leaderboardProvider.newList[2].userName!),
                                Text(
                                  leaderboardProvider.newList[2].taskPassingTime
                                      .toString(),
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
                                  color: Colors.yellow,
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
                  // Container(
                  //   height: 100,
                  //   color: Colors.white,
                  //   child: ListView.separated(
                  //       itemBuilder: (context, index) {
                  //         return Row(
                  //           children: [
                  //             Text(
                  //               leaderboardProvider.newList[index].userName!,
                  //             ),
                  //             Text(
                  //               leaderboardProvider
                  //                   .newList[index].taskPassingTime!
                  //                   .toString(),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //       separatorBuilder: (context, index) {
                  //         return const SizedBox(
                  //           height: 10,
                  //         );
                  //       },
                  //       itemCount: leaderboardProvider.newList.length),
                  // )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
