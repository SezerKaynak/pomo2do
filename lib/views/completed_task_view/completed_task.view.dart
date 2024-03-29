import 'package:flutter/material.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/completed_task_view/completed_task.widgets.dart';

class CompletedTasksView extends StatelessWidget with CompletedTasksWidgets {
  const CompletedTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(L10n.of(context)!.doneTask),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: body(context),
    );
  }
}
