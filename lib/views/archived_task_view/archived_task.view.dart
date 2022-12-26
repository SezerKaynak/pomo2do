import 'package:flutter/material.dart';
import 'package:pomotodo/views/archived_task_view/archived_task.widgets.dart';

class ArchivedTasksView extends StatelessWidget with ArchivedTasksWidgets {
  const ArchivedTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arşivlenmiş Görevler"),
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
