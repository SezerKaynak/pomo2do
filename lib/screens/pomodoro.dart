import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/screens/pomodoro_tabs/long_break_view.dart';
import 'package:flutter_application_1/screens/pomodoro_tabs/short_break_view.dart';
import 'package:flutter_application_1/pomodoro/pomodoro_timer.dart';
import 'package:flutter_application_1/providers/pomodoro_provider.dart';
import 'package:flutter_application_1/widgets/tabs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/pomodoro_tabs/focus_view.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key, required this.task});
  final TaskModel task;

  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView>
    with TickerProviderStateMixin {
  late TabController tabController;
  late CountDownController controller;
  int time = 0;

  final TextEditingController controller2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    controller = CountDownController();
  }

  @override
  Widget build(BuildContext context) {
    final pageUpdateNotifier = context.watch<PageUpdate>();
    return WillPopScope(
      onWillPop: () async => pageUpdateNotifier.onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Pomodoro"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                pageUpdateNotifier.onWillPop
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
                  width: MediaQuery.of(context).size.width,
                  child: IgnorePointer(
                    ignoring: !pageUpdateNotifier.startStop,
                    child: TabBar(
                      // labelColor: const Color.fromRGBO(4, 2, 46, 1),
                      // indicatorColor: const Color.fromRGBO(4, 2, 46, 1),
                      // unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      onTap: (_) {
                        pageUpdateNotifier.skipButtonVisible = false;
                      },
                      tabs: const [
                        Tabs(tabName: 'Pomodoro'),
                        Tabs(tabName: 'Kısa Ara'),
                        Tabs(tabName: 'Uzun Ara'),
                      ],
                    ),
                  )),
              Expanded(
                child: SizedBox(
                  child: TabBarView(
                    // physics: !pageUpdateNotifier.startStop
                    //     ? const NeverScrollableScrollPhysics()
                    //     : const AlwaysScrollableScrollPhysics(),
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      FocusView(
                          widget: widget,
                          controller: controller,
                          tabController: tabController),
                      ShortBreak(
                          widget: widget,
                          controller: controller,
                          tabController: tabController),
                      LongBreak(
                          widget: widget,
                          controller: controller,
                          tabController: tabController),
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
