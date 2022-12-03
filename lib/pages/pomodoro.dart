import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  int time = 0;

  final CountDownController controller = CountDownController();
  final TextEditingController controller2 = TextEditingController();
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
    return Consumer<PageUpdate>(
      builder: (context, value, child) {
        return WillPopScope(
          onWillPop: () async => context.read<PageUpdate>().onWillPop,
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Pomodoro"),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    context.read<PageUpdate>().onWillPop
                        ? Navigator.pop(context)
                        : DoNothingAction();
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
                          return IgnorePointer(
                            ignoring: !context.read<PageUpdate>().startStop,
                            child: TabBar(
                              labelColor: const Color.fromRGBO(4, 2, 46, 1),
                              indicatorColor: const Color.fromRGBO(4, 2, 46, 1),
                              unselectedLabelColor: Colors.grey,
                              controller: tabController,
                              onTap: (_) {
                                context.read<PageUpdate>().skipButtonVisible =
                                    false;
                              },
                              tabs: const [
                                Tabs(tabName: 'Pomodoro'),
                                Tabs(tabName: 'Kısa Ara'),
                                Tabs(tabName: 'Uzun Ara'),
                              ],
                            ),
                          );
                        },
                      )),
                  Expanded(
                    child: SizedBox(
                      child: TabBarView(
                        physics: !context.read<PageUpdate>().startStop
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TaskInfoListTile(
                                    taskName: widget.task.taskName,
                                    taskInfo: widget.task.taskInfo),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                time = snapshot.data * 60;
                                                return PomodoroTimer(
                                                  width: 300,
                                                  isReverse: true,
                                                  isReverseAnimation: true,
                                                  onComplete: () async {
                                                    context
                                                        .read<PageUpdate>()
                                                        .startOrStop(
                                                            time,
                                                            controller,
                                                            widget.task,
                                                            tabController);
                                                  },
                                                  duration: snapshot.data * 60,
                                                  autoStart: false,
                                                  controller: controller,
                                                  isTimerTextShown: true,
                                                  neumorphicEffect: true,
                                                  innerFillGradient:
                                                      LinearGradient(colors: [
                                                    Colors.greenAccent.shade200,
                                                    Colors.blueAccent.shade400
                                                  ]),
                                                  neonGradient:
                                                      LinearGradient(colors: [
                                                    Colors.greenAccent.shade200,
                                                    Colors.blueAccent.shade400
                                                  ]),
                                                );
                                              }
                                          }
                                        },
                                      ),
                                      Consumer<PageUpdate>(
                                        builder: (context, value, child) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        var btn = context
                                                            .read<PageUpdate>();
                                                        btn.startOrStop(
                                                            time,
                                                            controller,
                                                            widget.task,
                                                            tabController);
                                                        await FlutterLocalNotificationsPlugin().zonedSchedule(
                                                            0,
                                                            'scheduled title',
                                                            'scheduled body',
                                                            tz.TZDateTime.now(
                                                                    tz.local)
                                                                .add(const Duration(
                                                                    seconds:
                                                                        5)),
                                                            const NotificationDetails(
                                                                android: AndroidNotificationDetails(
                                                                    'your channel id',
                                                                    'your channel name',
                                                                    channelDescription:
                                                                        'your channel description',
                                                                    importance:
                                                                        Importance
                                                                            .max)),
                                                            androidAllowWhileIdle:
                                                                true,
                                                            uiLocalNotificationDateInterpretation:
                                                                UILocalNotificationDateInterpretation
                                                                    .absoluteTime);
                                                      },
                                                      child: context
                                                          .read<PageUpdate>()
                                                          .callText())),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .skipButtonVisible)
                                                IconButton(
                                                    onPressed: () {
                                                      tabController.animateTo(
                                                          tabController.index +
                                                              1);
                                                      context
                                                              .read<PageUpdate>()
                                                              .skipButtonVisible =
                                                          false;
                                                      context
                                                          .read<PageUpdate>()
                                                          .startStop = true;
                                                    },
                                                    icon: const Icon(
                                                        Icons.skip_next))
                                            ],
                                          );
                                        },
                                      )
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
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Material(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8))),
                                                color: Colors.green[100],
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: const SizedBox(
                                                    child: Center(
                                                      child: Text(
                                                        "Tamamlandı",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Material(
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(8),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8))),
                                                color: Colors.red[100],
                                                child: InkWell(
                                                    onTap: () {
                                                      SystemChrome
                                                          .setEnabledSystemUIMode(
                                                              SystemUiMode
                                                                  .immersiveSticky);
                                                    },
                                                    onLongPress: () {
                                                      SystemChrome
                                                          .setEnabledSystemUIMode(
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
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TaskInfoListTile(
                                    taskName: widget.task.taskName,
                                    taskInfo: widget.task.taskInfo),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FutureBuilder(
                                        future: _breakTime,
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
                                                time = snapshot.data * 60;
                                                return PomodoroTimer(
                                                  onComplete: () async {
                                                    context
                                                        .read<PageUpdate>()
                                                        .startOrStop(
                                                            time,
                                                            controller,
                                                            widget.task,
                                                            tabController);
                                                  },
                                                  width: 300,
                                                  isReverse: true,
                                                  isReverseAnimation: true,
                                                  duration: snapshot.data * 60,
                                                  autoStart: false,
                                                  controller: controller,
                                                  isTimerTextShown: true,
                                                  neumorphicEffect: true,
                                                  innerFillGradient:
                                                      LinearGradient(colors: [
                                                    Colors.greenAccent.shade200,
                                                    Colors.blueAccent.shade400
                                                  ]),
                                                  neonGradient:
                                                      LinearGradient(colors: [
                                                    Colors.greenAccent.shade200,
                                                    Colors.blueAccent.shade400
                                                  ]),
                                                );
                                              }
                                          }
                                        },
                                      ),
                                      Consumer<PageUpdate>(
                                        builder: (context, value, child) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Consumer<PageUpdate>(
                                                    builder: (context, value,
                                                        child) {
                                                      return ElevatedButton(
                                                          onPressed: () {
                                                            var btn =
                                                                context.read<
                                                                    PageUpdate>();
                                                            btn.startOrStop(
                                                                time,
                                                                controller,
                                                                widget.task,
                                                                tabController);
                                                          },
                                                          child: context
                                                              .read<
                                                                  PageUpdate>()
                                                              .callText());
                                                    },
                                                  )),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .skipButtonVisible)
                                                IconButton(
                                                    onPressed: () {
                                                      tabController.animateTo(
                                                          tabController.index +
                                                              1);
                                                      context
                                                          .read<PageUpdate>()
                                                          .startStop = true;
                                                      context
                                                              .read<PageUpdate>()
                                                              .skipButtonVisible =
                                                          false;
                                                    },
                                                    icon: const Icon(
                                                        Icons.skip_next))
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TaskInfoListTile(
                                    taskName: widget.task.taskName,
                                    taskInfo: widget.task.taskInfo),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FutureBuilder(
                                        future: _longBreakTime,
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
                                                time = snapshot.data * 60;
                                                return PomodoroTimer(
                                                  width: 300,
                                                  isReverse: true,
                                                  isReverseAnimation: true,
                                                  duration: snapshot.data * 60,
                                                  autoStart: false,
                                                  controller: controller,
                                                  isTimerTextShown: true,
                                                  neumorphicEffect: true,
                                                  innerFillGradient:
                                                      LinearGradient(colors: [
                                                    Colors.greenAccent.shade200,
                                                    Colors.blueAccent.shade400
                                                  ]),
                                                  neonGradient:
                                                      LinearGradient(colors: [
                                                    Colors.greenAccent.shade200,
                                                    Colors.blueAccent.shade400
                                                  ]),
                                                );
                                              }
                                          }
                                        },
                                      ),
                                      Consumer<PageUpdate>(
                                        builder: (context, value, child) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Consumer<PageUpdate>(
                                                    builder: (context, value,
                                                        child) {
                                                      return ElevatedButton(
                                                          onPressed: () {
                                                            var btn =
                                                                context.read<
                                                                    PageUpdate>();
                                                            btn.startOrStop(
                                                                time,
                                                                controller,
                                                                widget.task,
                                                                tabController);
                                                          },
                                                          child: context
                                                              .read<
                                                                  PageUpdate>()
                                                              .callText());
                                                    },
                                                  )),
                                              if (context
                                                  .read<PageUpdate>()
                                                  .skipButtonVisible)
                                                IconButton(
                                                    onPressed: () {
                                                      tabController
                                                          .animateTo(0);
                                                      context
                                                          .read<PageUpdate>()
                                                          .startStop = true;
                                                      context
                                                              .read<PageUpdate>()
                                                              .skipButtonVisible =
                                                          false;
                                                    },
                                                    icon: const Icon(
                                                        Icons.skip_next))
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class TaskInfoListTile extends StatelessWidget {
  const TaskInfoListTile({
    Key? key,
    required this.taskName,
    required this.taskInfo,
  }) : super(key: key);

  final String taskName;
  final String taskInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.schedule),
          const Icon(Icons.close),
          Text(
            '0',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 22),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 1)),
      title: Text(taskName),
      subtitle: Text(taskInfo),
      tileColor: Colors.blueGrey[50],
    );
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
