import 'package:flutter/material.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/task_statistics/task_statistics.widgets.dart';

class TaskStatisticsView extends StatefulWidget with TaskStatisticsWidget {
  const TaskStatisticsView({super.key});

  @override
  State<TaskStatisticsView> createState() => _TaskStatisticsViewState();
}

class _TaskStatisticsViewState extends State<TaskStatisticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.statisticsTitle),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: widget.body(context),
    );
  }
}
