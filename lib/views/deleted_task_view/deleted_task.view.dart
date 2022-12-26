import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/deleted_task_view/deleted_task.widgets.dart';

class DeletedTasksView extends StatelessWidget with DeletedTasksWidgets {
  const DeletedTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Çöp Kutusu"),
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
