import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/app_settings/app_settings.viewmodel.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_tabs/long_break_view.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_tabs/short_break_view.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/tabs.dart';
import 'package:provider/provider.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_tabs/focus_view.dart';
import 'package:quickalert/quickalert.dart';

class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key, required this.task});
  final TaskModel task;

  @override
  State<PomodoroWidget> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroWidget>
    with TickerProviderStateMixin, DatabaseService {
  late TabController tabController;
  late CountDownController controller;
  late TextEditingController controller2;
  int time = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    controller = CountDownController();
    controller2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = L10n.of(context)!;
    final pageUpdateNotifier = context.watch<PageUpdate>();
    return WillPopScope(
      onWillPop: () async => pageUpdateNotifier.onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.pomodoro),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              pageUpdateNotifier.onWillPop
                  ? widget.task.pomodoroCount != 0
                      ? context
                              .read<AppSettingsController>()
                              .warnSetting
                          ? QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              title: l10n.uSure,
                              text: l10n.pomodoroWillReset,
                              confirmBtnText: l10n.alertApprove,
                              cancelBtnText: l10n.alertReject,
                              confirmBtnColor: Colors.green,
                              onConfirmBtnTap: () {
                                widget.task.pomodoroCount = 0;
                                updateTask(widget.task);
                                Navigator.pop(context);
                              },
                            )
                          : {
                              widget.task.pomodoroCount = 0,
                              updateTask(widget.task),
                              Navigator.pop(context)
                            }
                      : Navigator.pop(context)
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
                    controller: tabController,
                    onTap: (_) {
                      pageUpdateNotifier.skipButtonVisible = false;
                    },
                    tabs: [
                      Tabs(tabName: l10n.pomodoro),
                      Tabs(tabName: l10n.shortBreak),
                      Tabs(tabName: l10n.longBreak),
                    ],
                  ),
                )),
            Expanded(
              child: SizedBox(
                child: TabBarView(
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    controller2.dispose();
    super.dispose();
  }
}
