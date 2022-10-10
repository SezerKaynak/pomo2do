import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key, required this.task});
  final TaskModel task;
  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  final CountDownController controller = CountDownController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pomodoro"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      ScreenTexts(
                          title: widget.task.taskName,
                          theme: Theme.of(context).textTheme.headline6,
                          fontW: FontWeight.w400,
                          textPosition: TextAlign.left),
                      ScreenTexts(
                          title: widget.task.taskInfo,
                          theme: Theme.of(context).textTheme.subtitle1,
                          fontW: FontWeight.w400,
                          textPosition: TextAlign.left)
                    ],
                  )),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    PomodoroTimer(
                      width: 300,
                      isReverse: true,
                      isReverseAnimation: true,
                      duration: 25 * 60,
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
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                controller.resume();
                              }),
                          IconButton(
                              icon: const Icon(Icons.pause),
                              onPressed: () {
                                controller.pause();
                              }),
                          IconButton(
                              icon: const Icon(Icons.repeat),
                              onPressed: () {
                                controller.restart();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
