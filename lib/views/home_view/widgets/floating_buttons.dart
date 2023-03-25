import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/select_icon_provider.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/views/home_view/widgets/add_task_widget.dart';
import 'package:provider/provider.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            heroTag: "btn1",
            onPressed: () {
              Navigator.pushNamed(context, '/taskStatistics');
            },
            child: const Icon(Icons.stacked_bar_chart),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/leaderboard');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            heroTag: "btn3",
            child: const Icon(Icons.leaderboard),
          ),
          FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            heroTag: "btn2",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                builder: (BuildContext context) {
                  return ChangeNotifierProvider(
                      create: (context) => SelectIcon(),
                      child: const AddTaskWidget());
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
