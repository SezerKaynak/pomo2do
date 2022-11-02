import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key, required this.task});
  final TaskModel task;
  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _count;

  @override
  void initState() {
    super.initState();
    _count = _prefs.then((SharedPreferences prefs) {
      if(prefs.getInt('workTimerSelect') == null){
        setPomodoroSettings(prefs);
      }
      return prefs.getInt('workTimerSelect') ?? 0;
    });
  }

  void setPomodoroSettings(SharedPreferences prefs) async {
    await prefs.setInt('workTimerSelect', 25);
    await prefs.setInt('breakTimerSelect', 5);
    await prefs.setInt('longBreakTimerSelect', 15);
    await prefs.setInt('longBreakNumberSelect', 1);
  }

  @override
  Widget build(BuildContext context) {
    final CountDownController controller = CountDownController();
    final TextEditingController controller2 = TextEditingController();
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
        resizeToAvoidBottomInset: false,
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
                    FutureBuilder(
                      future: _count,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return PomodoroTimer(
                                width: 300,
                                isReverse: true,
                                isReverseAnimation: true,
                                duration: int.parse(snapshot.data
                                        .toString()
                                        .substring(0, 2)) *
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
                              );
                            }
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    controller.resume();
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.pause),
                                  onPressed: () async {
                                    controller.pause();
                                    // var countDown = controller
                                    //     .getTime()
                                    //     .substring(0, 5)
                                    //     .replaceAll(':', '.');

                                    // controller2.text = (double.parse(count) -
                                    //         double.parse(countDown) -
                                    //         1)
                                    //     .toString()
                                    //     .substring(0, 4);

                                    // print(int.parse(count.substring(0, 2)));

                                    CollectionReference users =
                                        FirebaseFirestore.instance.collection(
                                            'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
                                    var task = users.doc(widget.task.id);
                                    await task.set({
                                      'taskNameCaseInsensitive':
                                          widget.task.taskName.toLowerCase(),
                                      'taskName': widget.task.taskName,
                                      'taskType': widget.task.taskType,
                                      'taskInfo': widget.task.taskInfo,
                                      "isDone": widget.task.isDone,
                                      "isActive": widget.task.isActive,
                                      "isArchive": widget.task.isArchive,
                                      "passingTime": controller2.text
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.repeat),
                                  onPressed: () {
                                    controller.restart();
                                  }),
                            ],
                          ),
                          ScreenTextField(
                              textLabel: controller2.text,
                              obscure: false,
                              controller: controller2,
                              height: 60,
                              maxLines: 1)
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
