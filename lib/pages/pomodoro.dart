import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key, required this.task});
  final TaskModel task;
  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView>
    with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _workTime;
  late Future<int> _breakTime;
  late Future<int> _longBreakTime;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    _workTime = _prefs.then((SharedPreferences prefs) {
      if (prefs.getInt('workTimerSelect') == null) {
        setPomodoroSettings(prefs);
      }
      return prefs.getInt('workTimerSelect') ?? 0;
    });
    _breakTime = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('breakTimerSelect') ?? 0;
    });
    _longBreakTime = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('longBreakTimerSelect') ?? 0;
    });
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
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
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: 400,
                child: Consumer<PageUpdate>(
                  builder: (context, value, child) {
                    return TabBar(
                      labelColor: const Color.fromRGBO(4, 2, 46, 1),
                      indicatorColor: const Color.fromRGBO(4, 2, 46, 1),
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      onTap: (_) {
                        context.read<PageUpdate>().skipButtonPomodoroVisible =
                            false;
                        context.read<PageUpdate>().skipButtonBreakVisible =
                            false;
                      },
                      tabs: const [
                        Tabs(tabName: 'Pomodoro'),
                        Tabs(tabName: 'Kısa Ara'),
                        Tabs(tabName: 'Uzun Ara'),
                      ],
                    );
                  },
                )),
            Expanded(
              child: SizedBox(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  ScreenTexts(
                                      title: widget.task.taskName,
                                      theme:
                                          Theme.of(context).textTheme.headline6,
                                      fontW: FontWeight.w400,
                                      textPosition: TextAlign.left),
                                  ScreenTexts(
                                      title: widget.task.taskInfo,
                                      theme:
                                          Theme.of(context).textTheme.subtitle1,
                                      fontW: FontWeight.w400,
                                      textPosition: TextAlign.left)
                                ],
                              )),
                          Expanded(
                            flex: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FutureBuilder(
                                  future: _workTime,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const CircularProgressIndicator();
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
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
                                            innerFillGradient: LinearGradient(
                                                colors: [
                                                  Colors.greenAccent.shade200,
                                                  Colors.blueAccent.shade400
                                                ]),
                                            neonGradient: LinearGradient(
                                                colors: [
                                                  Colors.greenAccent.shade200,
                                                  Colors.blueAccent.shade400
                                                ]),
                                          );
                                        }
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Consumer<PageUpdate>(
                                      builder: (context, value, child) {
                                        return Row(
                                          children: [
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      var startButtonWork =
                                                          context.read<
                                                              PageUpdate>();
                                                      startButtonWork
                                                          .startButtonPomodoro(
                                                              controller);
                                                    },
                                                    child:
                                                        const Text("BAŞLA"))),
                                            if (context
                                                .read<PageUpdate>()
                                                .stopButtonPomodoroVisible)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          controller.pause();
                                                        },
                                                        child: const Text(
                                                            "DURDUR"))),
                                              ),
                                            if (context
                                                .read<PageUpdate>()
                                                .resumeButtonPomodoroVisible)
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        controller.resume();
                                                      },
                                                      child: const Text(
                                                          "DEVAM ET"))),
                                            if (context
                                                .read<PageUpdate>()
                                                .skipButtonPomodoroVisible)
                                              IconButton(
                                                  onPressed: () {
                                                    tabController.index = 1;
                                                  },
                                                  icon: const Icon(
                                                      Icons.skip_next)),
                                          ],
                                        );
                                      },
                                    )

                                    // IconButton(
                                    //     icon:
                                    //         const Icon(Icons.play_arrow),
                                    //     onPressed: () {
                                    //       controller.resume();
                                    //     }),
                                    // IconButton(
                                    //     icon: const Icon(Icons.pause),
                                    //     onPressed: () async {
                                    //       controller.pause();
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

                                    // CollectionReference users =
                                    //     FirebaseFirestore.instance.collection(
                                    //         'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
                                    // var task = users.doc(widget.task.id);
                                    // await task.set({
                                    //   'taskNameCaseInsensitive': widget
                                    //       .task.taskName
                                    //       .toLowerCase(),
                                    //   'taskName': widget.task.taskName,
                                    //   'taskType': widget.task.taskType,
                                    //   'taskInfo': widget.task.taskInfo,
                                    //   "isDone": widget.task.isDone,
                                    //   "isActive": widget.task.isActive,
                                    //   "isArchive": widget.task.isArchive,
                                    //   "passingTime": controller2.text
                                    // });
                                    //     }),
                                    // IconButton(
                                    //     icon: const Icon(Icons.repeat),
                                    //     onPressed: () {
                                    //       controller.restart();
                                    //     }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: _breakTime,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  PomodoroTimer(
                                    width: 300,
                                    isReverse: true,
                                    isReverseAnimation: true,
                                    duration: int.parse(snapshot.data
                                            .toString()
                                            .substring(0, 1)) *
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
                                      Consumer<PageUpdate>(
                                        builder: (context, value, child) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        var startButtonWork =
                                                            context.read<
                                                                PageUpdate>();
                                                        startButtonWork
                                                            .startButtonBreak(
                                                                controller);
                                                      },
                                                      child:
                                                          const Text("BAŞLA"))),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .stopButtonBreakVisible)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            controller.pause();
                                                          },
                                                          child: const Text(
                                                              "DURDUR"))),
                                                ),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .resumeButtonBreakVisible)
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          controller.resume();
                                                        },
                                                        child: const Text(
                                                            "DEVAM ET"))),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .skipButtonBreakVisible)
                                                IconButton(
                                                    onPressed: () {
                                                      tabController.index = 2;
                                                    },
                                                    icon: const Icon(
                                                        Icons.skip_next)),
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
                              );
                            }
                        }
                      },
                    ),
                    FutureBuilder(
                      future: _longBreakTime,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  PomodoroTimer(
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
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer<PageUpdate>(
                                        builder: (context, value, child) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        var startButtonWork =
                                                            context.read<
                                                                PageUpdate>();
                                                        startButtonWork
                                                            .startButtonLongBreak(
                                                                controller);
                                                      },
                                                      child:
                                                          const Text("BAŞLA"))),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .stopButtonLongBreakVisible)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            controller.pause();
                                                          },
                                                          child: const Text(
                                                              "DURDUR"))),
                                                ),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .resumeButtonLongBreakVisible)
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          controller.resume();
                                                        },
                                                        child: const Text(
                                                            "DEVAM ET"))),
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class Tabs extends StatelessWidget {
  const Tabs({
    Key? key,
    required this.tabName,
  }) : super(key: key);
  final String tabName;
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        size: Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: Center(child: Text(tabName)));
  }
}

class PageUpdate extends ChangeNotifier {
  bool skipButtonPomodoroVisible = false;
  bool stopButtonPomodoroVisible = false;
  bool resumeButtonPomodoroVisible = false;
  bool skipButtonBreakVisible = false;
  bool stopButtonBreakVisible = false;
  bool resumeButtonBreakVisible = false;
  bool stopButtonLongBreakVisible = false;
  bool resumeButtonLongBreakVisible = false;

  void startButtonPomodoro(CountDownController controller) {
    controller.resume();
    skipButtonPomodoroVisible = true;
    stopButtonPomodoroVisible = true;
    resumeButtonPomodoroVisible = true;
    notifyListeners();
  }

  void startButtonBreak(CountDownController controller) {
    controller.resume();
    skipButtonBreakVisible = true;
    stopButtonBreakVisible = true;
    resumeButtonBreakVisible = true;
    notifyListeners();
  }

  void startButtonLongBreak(CountDownController controller) {
    controller.resume();
    stopButtonLongBreakVisible = true;
    resumeButtonLongBreakVisible = true;
    notifyListeners();
  }
}
