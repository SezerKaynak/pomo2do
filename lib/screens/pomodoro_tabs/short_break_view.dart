import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/pomodoro.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_controller.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortBreak extends StatelessWidget {
  const ShortBreak({
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TaskInfoListTile(
              taskName: widget.task.taskName, taskInfo: widget.task.taskInfo),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PomodoroTimer(
                  onComplete: () async {
                    context.read<PageUpdate>().startOrStop(
                        context
                            .read<SharedPreferences>()
                            .getInt("breakTimerSelect")!,
                        controller,
                        widget.task,
                        tabController);
                  },
                  width: MediaQuery.of(context).size.width * 0.7,
                  isReverse: true,
                  isReverseAnimation: true,
                  duration: context.select((SharedPreferences prefs) =>
                          prefs.getInt("breakTimerSelect"))! *
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
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            onPressed: () {
                              var btn = context.read<PageUpdate>();
                              btn.startOrStop(
                                  context
                                      .read<SharedPreferences>()
                                      .getInt("breakTimerSelect")!,
                                  controller,
                                  widget.task,
                                  tabController);
                            },
                            child: context.read<PageUpdate>().callText())),
                    if (context.read<PageUpdate>().skipButtonVisible)
                      IconButton(
                          onPressed: () {
                            tabController.animateTo(tabController.index + 1);
                            context.read<PageUpdate>().startStop = true;
                            context.read<PageUpdate>().skipButtonVisible =
                                false;
                          },
                          icon: const Icon(Icons.skip_next))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
