import 'package:flutter/material.dart';
import 'package:pomotodo/views/edit_task_view/edit_task.widgets.dart';

class EditTaskView extends StatelessWidget with EditTaskWidgets {
  const EditTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }
}
