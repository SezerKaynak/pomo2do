import 'package:flutter/material.dart';

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
          const Icon(Icons.schedule),
          const Icon(Icons.close),
          Text(
            '0',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 22),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 1)),
      title: Text(taskName),
      subtitle: Text(taskInfo),
      tileColor: Colors.blueGrey[50],
    );
  }
}