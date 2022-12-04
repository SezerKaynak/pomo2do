import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/pomodoro.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_controller.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ignore: must_be_immutable
class FocusView extends StatelessWidget {
  FocusView({
    Key? key,
    required this.widget,
    required Future<int> workTime,
    required this.controller,
    required this.tabController,
  }) : super(key: key);

  final PomodoroView widget;
  final CountDownController controller;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TaskInfoListTile(
              taskName: widget.task.taskName, taskInfo: widget.task.taskInfo),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PomodoroTimer(
                  width: 300,
                  isReverse: true,
                  isReverseAnimation: true,
                  onComplete: () async {
                    context.read<PageUpdate>().startOrStop(
                        context
                            .read<SharedPreferences>()
                            .getInt("workTimerSelect")!,
                        controller,
                        widget.task,
                        tabController);
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
                  duration: context
                          .read<SharedPreferences>()
                          .getInt("workTimerSelect")! *
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                            onPressed: () {
                              var btn = context.watch<PageUpdate>();
                              btn.startOrStop(
                                  context
                                      .read<SharedPreferences>()
                                      .getInt("workTimerSelect")!,
                                  controller,
                                  widget.task,
                                  tabController);
                            },
                            child: context.read<PageUpdate>().callText())),
                    if (context.read<PageUpdate>().skipButtonVisible)
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
                          color: Colors.green[100],
                          child: InkWell(
                            onTap: () {},
                            child: const SizedBox(
                              child: Center(
                                child: Text(
                                  "Tamamlandı",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                          color: Colors.red[100],
                          child: InkWell(
                              onTap: () {
                                SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.immersiveSticky);
                              },
                              onLongPress: () {
                                SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: [
                                    SystemUiOverlay.top,
                                    SystemUiOverlay.bottom
                                  ],
                                );
                              },
                              child: const SizedBox(
                                child: Center(
                                    child: Text(
                                  'Tam Ekran',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              )),
                        ),
                      )
                    ],
                  ),
                )
                // ListTile(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       side: const BorderSide(
                //           color: Colors.black, width: 1)),
                // ),
                ),
          )
        ],
      ),
    );
  }
}
