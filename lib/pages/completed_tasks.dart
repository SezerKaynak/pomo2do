import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';

class CompletedTasks extends StatelessWidget {
  const CompletedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    List<TaskModel> tasks =
        ModalRoute.of(context)!.settings.arguments as List<TaskModel>;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tamamlanmış Görevler"),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
        itemCount: numberOfCompletedTasks(tasks).length,
        itemBuilder: (context, index) {
          final TaskModel data = numberOfCompletedTasks(tasks)[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const Icon(Icons.numbers),
                    onTap: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    title: Text(data.taskName),
                    subtitle: Text(data.taskInfo),
                    trailing: const Icon(Icons.arrow_right_sharp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List numberOfCompletedTasks(List<TaskModel> tasks) {
    var completedTasks = [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].isDone == true) {
        completedTasks.add(tasks[i]);
      }
    }
    return completedTasks;
  }
}
