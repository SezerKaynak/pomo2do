import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/task_info_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LongBreak extends StatefulWidget {
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
  State<LongBreak> createState() => _LongBreakState();
}

class _LongBreakState extends State<LongBreak> with WidgetsBindingObserver {
  late DateTime firstDateTime;
  late DateTime secondDateTime;
  late PageUpdate pageUpdateProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    pageUpdateProvider = Provider.of<PageUpdate>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (pageUpdateProvider.timerWorking) {
      switch (state) {
        case AppLifecycleState.paused:
          pageUpdateProvider.timerWorking = true;
          context.read<PageUpdate>().startOrStop(
              context
                      .read<SharedPreferences>()
                      .getInt("longBreakTimerSelect")! *
                  60,
              widget.controller,
              widget.widget.task,
              widget.tabController,
              context
                  .read<SharedPreferences>()
                  .getInt("longBreakNumberSelect")!);
          firstDateTime = DateTime.now();
          break;
        case AppLifecycleState.resumed:
          secondDateTime = DateTime.now();
          var differenceDateTime = secondDateTime.difference(firstDateTime);
          var newDuration = widget.controller.getTimeInSeconds() -
              differenceDateTime.inSeconds;
          context
              .read<PageUpdate>()
              .restartTimer(widget.controller, newDuration);

          pageUpdateProvider.timerWorking = false;
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TaskInfoListTile(
            taskName: widget.widget.task.taskName,
            taskInfo: widget.widget.task.taskInfo,
            pomodoroCount: widget.widget.task.pomodoroCount,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RepaintBoundary(
                  child: PomodoroTimer(
                    width: MediaQuery.of(context).size.width * 0.65,
                    onComplete: () {
                      pageUpdateProvider.startOrStop(
                          context
                                  .read<SharedPreferences>()
                                  .getInt("longBreakTimerSelect")! *
                              60,
                          widget.controller,
                          widget.widget.task,
                          widget.tabController,
                          context
                              .read<SharedPreferences>()
                              .getInt("longBreakNumberSelect")!);
                    },
                    isReverse: true,
                    isReverseAnimation: true,
                    duration: context.select((SharedPreferences prefs) =>
                            prefs.getInt("longBreakTimerSelect")!) *
                        60,
                    autoStart: false,
                    controller: widget.controller,
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
                        pageUpdateProvider.startOrStop(
                            context
                                    .read<SharedPreferences>()
                                    .getInt("longBreakTimerSelect")! *
                                60,
                            widget.controller,
                            widget.widget.task,
                            widget.tabController,
                            context
                                .read<SharedPreferences>()
                                .getInt("longBreakNumberSelect")!);
                      },
                      child: context.select(
                        (PageUpdate pageNotifier) => pageNotifier.callText(),
                      ),
                    ),
                    if (pageUpdateProvider.skipButtonVisible)
                      IconButton(
                        onPressed: () {
                          pageUpdateProvider.startOrStop(
                              context
                                      .read<SharedPreferences>()
                                      .getInt("longBreakTimerSelect")! *
                                  60,
                              widget.controller,
                              widget.widget.task,
                              widget.tabController,
                              context
                                  .read<SharedPreferences>()
                                  .getInt("longBreakNumberSelect")!);
                          widget.tabController.animateTo(0);
                        },
                        icon: const Icon(Icons.skip_next),
                      )
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
