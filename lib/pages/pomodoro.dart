import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/pomodoro_tabs/long_break_view.dart';
import 'package:flutter_application_1/pages/pomodoro_tabs/short_break_view.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/pages/pomodoro_tabs/focus_view.dart';

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
  late CountDownController controller;
  int time = 0;

  final TextEditingController controller2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    _workTime = _prefs.then((SharedPreferences prefs) {
      if (prefs.getInt('workTimerSelect') == null) {
        setPomodoroSettings(prefs);
      }
      return prefs.getInt('workTimerSelect')!;
    });
    _breakTime = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('breakTimerSelect')!;
    });
    _longBreakTime = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('longBreakTimerSelect')!;
    });
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    controller = CountDownController();
  }

  void setPomodoroSettings(SharedPreferences prefs) async {
    await prefs.setInt('workTimerSelect', 25);
    await prefs.setInt('breakTimerSelect', 5);
    await prefs.setInt('longBreakTimerSelect', 15);
    await prefs.setInt('longBreakNumberSelect', 1);
  }

  @override
  Widget build(BuildContext context) {
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
                        physics: !context.watch<PageUpdate>().startStop
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          FocusView(widget: widget, workTime: _workTime, controller: controller, tabController: tabController),
                          ShortBreak(widget: widget, breakTime: _breakTime, time: time, controller: controller, tabController: tabController),
                          LongBreak(widget: widget, longBreakTime: _longBreakTime, controller: controller, time: time, tabController: tabController),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
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
