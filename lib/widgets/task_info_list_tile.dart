import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          const Icon(Icons.schedule, color: Colors.black),
          const Icon(Icons.close, color: Colors.black),
          Text(
            context.select((SharedPreferences prefs) => prefs.getInt("PomodoroCount").toString()),
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 22, color: Colors.black),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 1)),
      title: Text(taskName, style: const TextStyle(color: Colors.black)),
      subtitle: Text(taskInfo, style: const TextStyle(color: Colors.black)),
      tileColor: Colors.blueGrey[50],
    );
  }
}