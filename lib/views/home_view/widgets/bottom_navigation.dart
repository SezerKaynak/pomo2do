import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/providers/tasks_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOfTasks = Provider.of<TasksProvider>(context);
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archive"),
        BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
        BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Trash")
      ],
      onTap: (selectedIndex) {
        switch (selectedIndex) {
          case 0:
            Navigator.pushNamed(
              context,
              '/archived',
            ).then((_) => providerOfTasks.refresh());

            break;
          case 1:
            Navigator.pushNamed(
              context,
              '/done',
            ).then((_) => providerOfTasks.refresh());

            break;
          case 2:
            Navigator.pushNamed(
              context,
              '/deleted',
            ).then((_) => providerOfTasks.refresh());

            break;
          default:
        }
      },
    );
  }
}
