import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/core/providers/spotify_provider.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/spotify_build_player_state.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/task_info_list_tile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FocusView extends StatefulWidget {
  const FocusView({
    Key? key,
    required this.widget,
    required this.controller,
    required this.tabController,
  }) : super(key: key);

  final PomodoroWidget widget;
  final CountDownController controller;
  final TabController tabController;

  @override
  State<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView> {
  @override
  Widget build(BuildContext context) {
    SpotifyProvider spotifyProvider =
        Provider.of<SpotifyProvider>(context, listen: true);
    int pomodoroCount = widget.widget.task.pomodoroCount;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TaskInfoListTile(
              taskName: widget.widget.task.taskName,
              taskInfo: widget.widget.task.taskInfo,
              pomodoroCount: widget.widget.task.pomodoroCount),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RepaintBoundary(
                  child: PomodoroTimer(
                    backgroudColor: Theme.of(context).focusColor,
                    width: MediaQuery.of(context).size.width * 0.7,
                    isReverse: true,
                    isReverseAnimation: true,
                    onComplete: () async {
                      context.read<PageUpdate>().startOrStop(
                          context
                                  .read<SharedPreferences>()
                                  .getInt("workTimerSelect")! *
                              60,
                          widget.controller,
                          widget.widget.task,
                          widget.tabController,
                          context
                              .read<SharedPreferences>()
                              .getInt("longBreakNumberSelect")!);
                      context.read<PageUpdate>().floatingActionOnPressed(
                          widget.widget.task, pomodoroCount + 1);
                      await FlutterLocalNotificationsPlugin().zonedSchedule(
                          0,
                          'scheduled title',
                          'scheduled body',
                          tz.TZDateTime.now(tz.local)
                              .add(const Duration(seconds: 1)),
                          const NotificationDetails(
                              android: AndroidNotificationDetails(
                                  'your channel id', 'your channel name',
                                  channelDescription:
                                      'your channel description',
                                  importance: Importance.max)),
                          androidAllowWhileIdle: true,
                          uiLocalNotificationDateInterpretation:
                              UILocalNotificationDateInterpretation
                                  .absoluteTime);
                    },
                    duration: context.select((SharedPreferences prefs) =>
                            prefs.getInt("workTimerSelect"))! *
                        60,
                    autoStart: false,
                    controller: widget.controller,
                    isTimerTextShown: true,
                    neumorphicEffect: true,
                    innerFillGradient: LinearGradient(colors: [
                      Colors.greenAccent.shade200,
                      Colors.blueAccent.shade400
                    ]),
                    neonGradient: LinearGradient(colors: [
                      Colors.greenAccent.shade200,
                      Colors.blueAccent.shade400
                    ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                            onPressed: () {
                              var btn = context.read<PageUpdate>();
                              btn.startOrStop(
                                  context
                                          .read<SharedPreferences>()
                                          .getInt("workTimerSelect")! *
                                      60,
                                  widget.controller,
                                  widget.widget.task,
                                  widget.tabController,
                                  context
                                      .read<SharedPreferences>()
                                      .getInt("longBreakNumberSelect")!);
                            },
                            child: context.select((PageUpdate pageNotifier) =>
                                pageNotifier.callText()))),
                    if (context.select((PageUpdate pageNotifier) =>
                        pageNotifier.skipButtonVisible))
                      IconButton(
                          onPressed: () {
                            widget.tabController
                                .animateTo(widget.tabController.index + 1);
                            context.read<PageUpdate>().skipButtonVisible =
                                false;
                            context.read<PageUpdate>().startStop = true;
                          },
                          icon: const Icon(Icons.skip_next))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: kToolbarHeight * 2,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            height: kToolbarHeight,
                            child: Row(
                              children: [
                                spotifyProvider.connected
                                    ? Expanded(
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                buildPlayerStateWidget(context),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                              height: kToolbarHeight,
                                              child: InkWell(
                                                onTap: () async {
                                                  try {
                                                    await context
                                                        .read<SpotifyProvider>()
                                                        .connectToSpotifyRemote();
                                                  } on PlatformException catch (e) {
                                                    QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType
                                                            .error,
                                                        title:
                                                            "Bağlanamadı!",
                                                        text: e.code,
                                                        confirmBtnText:
                                                            confirmButtonText);
                                                  }
                                                },
                                                child: const Center(
                                                    child: Text(
                                                  "Spotify'a Bağlan",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                              ),
                                            ),
                                            Center(
                                              child: Visibility(
                                                  visible:
                                                      spotifyProvider.loading,
                                                  child:
                                                      const CircularProgressIndicator(
                                                          color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Material(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8))),
                                  color: Colors.green[500],
                                  child: InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                      //metni görevi tamamlandı olarak işaretle cümlesine benzer bir cümleyle değiştir
                                      child: Center(
                                        child: Wrap(
                                          children: const [
                                            Text(
                                              "Tamamlandı Olarak İşaretle",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8))),
                                  color: Colors.red[400],
                                  child: InkWell(
                                      onTap: () {
                                        context
                                            .read<PageUpdate>()
                                            .floatingActionOnPressed(
                                                widget.widget.task, 0);
                                      },
                                      child: SizedBox(
                                        child: Center(
                                            child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          direction: Axis.vertical,
                                          children: const [
                                            Text('Pomodoro Sayacını',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              'Sıfırla',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
