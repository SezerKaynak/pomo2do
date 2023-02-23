import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/task_info_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortBreak extends StatelessWidget {
  const ShortBreak({
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
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RepaintBoundary(
                  child: PomodoroTimer(
                    width: MediaQuery.of(context).size.width * 0.65,
                    onComplete: () async {
                      context.read<PageUpdate>().startOrStop(
                          context
                                  .read<SharedPreferences>()
                                  .getInt("breakTimerSelect")! *
                              60,
                          controller,
                          widget.task,
                          tabController,
                          context
                              .read<SharedPreferences>()
                              .getInt("longBreakNumberSelect")!);
                    },
                    isReverse: true,
                    isReverseAnimation: true,
                    duration: context.select((SharedPreferences prefs) =>
                            prefs.getInt("breakTimerSelect"))! *
                        60,
                    autoStart: false,
                    controller: controller,
                    isTimerTextShown: true,
                    neumorphicEffect: false,
                    strokeWidth: 20,
                    innerFillColor: Theme.of(context).primaryColor,
                    neonColor: Theme.of(context).primaryColor,
                    backgroudColor: Theme.of(context).focusColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      buttonHeight: MediaQuery.of(context).size.height * 0.06,
                      buttonWidth: MediaQuery.of(context).size.width * 0.5,
                      onPressed: () {
                        var btn = context.read<PageUpdate>();
                        btn.startOrStop(
                            context
                                    .read<SharedPreferences>()
                                    .getInt("breakTimerSelect")! *
                                60,
                            controller,
                            widget.task,
                            tabController,
                            context
                                .read<SharedPreferences>()
                                .getInt("longBreakNumberSelect")!);
                      },
                      child: context.select(
                        (PageUpdate pageNotifier) => pageNotifier.callText(),
                      ),
                    ),
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
