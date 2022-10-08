import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/task.dart';


class PomodoroView extends StatelessWidget {
  const PomodoroView({super.key, required this.task});

  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pomodoro"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TaskView()),
                  ModalRoute.withName("task"));
            },
          ),
        ),
        body: Column(
          children: [
            Text(task.taskName),
          ],
        ));
  }
}
