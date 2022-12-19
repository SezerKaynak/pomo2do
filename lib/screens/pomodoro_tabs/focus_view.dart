import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/pomodoro.dart';
import 'package:flutter_application_1/providers/pomodoro_provider.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_application_1/widgets/task_info_list_tile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FocusView extends StatelessWidget {
  const FocusView({
    Key? key,
    required this.widget,
    required this.controller,
    required this.tabController,
  }) : super(key: key);

  final PomodoroView widget;
  final CountDownController controller;
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    int pomodoroCount = widget.task.pomodoroCount;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TaskInfoListTile(
              taskName: widget.task.taskName,
              taskInfo: widget.task.taskInfo,
              pomodoroCount: widget.task.pomodoroCount),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
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
                          controller,
                          widget.task,
                          tabController,
                          context
                              .read<SharedPreferences>()
                              .getInt("longBreakNumberSelect")!);
                      context.read<PageUpdate>().floatingActionOnPressed(
                          widget.task, pomodoroCount + 1);
                      await FlutterLocalNotificationsPlugin().zonedSchedule(
                          0,
                          'scheduled title',
                          'scheduled body',
                          tz.TZDateTime.now(tz.local)
                              .add(const Duration(seconds: 1)),
                          const NotificationDetails(
                              android: AndroidNotificationDetails(
                                  'your channel id', 'your channel name',
                                  channelDescription: 'your channel description',
                                  importance: Importance.max)),
                          androidAllowWhileIdle: true,
                          uiLocalNotificationDateInterpretation:
                              UILocalNotificationDateInterpretation.absoluteTime);
                    },
                    duration: context.select((SharedPreferences prefs) =>
                            prefs.getInt("workTimerSelect"))! *
                        60,
                    autoStart: false,
                    controller: controller,
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
                                  controller,
                                  widget.task,
                                  tabController,
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
                            tabController.animateTo(tabController.index + 1);
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
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Material(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
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
                                      "Tamamlandı",
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
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          color: Colors.red[400],
                          child: InkWell(
                              // onTap: () {
                              //   SystemChrome.setEnabledSystemUIMode(
                              //       SystemUiMode.immersiveSticky);
                              // },
                              // onLongPress: () {
                              //   SystemChrome.setEnabledSystemUIMode(
                              //     SystemUiMode.manual,
                              //     overlays: [
                              //       SystemUiOverlay.top,
                              //       SystemUiOverlay.bottom
                              //     ],
                              //   );
                              // },
                              onTap: () {
                                context
                                    .read<PageUpdate>()
                                    .floatingActionOnPressed(widget.task, 0);
                              },
                              child: SizedBox(
                                child: Center(
                                    child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: const [
                                    Text('Pomodoro Sayacını',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                )),
          )
        ],
      ),
    );
  }
}
