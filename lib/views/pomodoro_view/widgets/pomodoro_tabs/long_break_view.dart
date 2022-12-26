import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/task_info_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LongBreak extends StatelessWidget {
  const LongBreak({
    Key? key,
    required this.widget,
    required this.controller,
    required this.tabController,
  }) : super(key: key);

  final PomodoroWidget widget;
  final CountDownController controller;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TaskInfoListTile(
            taskName: widget.task.taskName,
            taskInfo: widget.task.taskInfo,
            pomodoroCount: widget.task.pomodoroCount,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RepaintBoundary(
                  child: PomodoroTimer(
                    backgroudColor: Colors.black26,
                    onComplete: () {
                      context.read<PageUpdate>().startOrStop(
                          context
                                  .read<SharedPreferences>()
                                  .getInt("longBreakTimerSelect")! *
                              60,
                          controller,
                          widget.task,
                          tabController,
                          context
                              .read<SharedPreferences>()
                              .getInt("longBreakNumberSelect")!);
                    },
                    width: MediaQuery.of(context).size.width * 0.7,
                    isReverse: true,
                    isReverseAnimation: true,
                    duration: context.select((SharedPreferences prefs) =>
                            prefs.getInt("longBreakTimerSelect")!) *
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
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            onPressed: () {
                              context.read<PageUpdate>().startOrStop(
                                  context
                                          .read<SharedPreferences>()
                                          .getInt("longBreakTimerSelect")! *
                                      60,
                                  controller,
                                  widget.task,
                                  tabController,
                                  context
                                      .read<SharedPreferences>()
                                      .getInt("longBreakNumberSelect")!);
                            },
                            child: context.read<PageUpdate>().callText())),
                    if (context.read<PageUpdate>().skipButtonVisible)
                      IconButton(
                          onPressed: () {
                            tabController.animateTo(0);
                            context.read<PageUpdate>().startStop = true;
                            context.read<PageUpdate>().skipButtonVisible =
                                false;
                          },
                          icon: const Icon(Icons.skip_next))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
