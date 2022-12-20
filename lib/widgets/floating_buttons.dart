import 'package:flutter/material.dart';
import 'package:flutter_application_1/assets/constants.dart';
import 'package:flutter_application_1/screens/add_task.dart';

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
            heroTag: "btn1",
            onPressed: () {
              Navigator.pushNamed(context, '/deneme');
            },
            child: const Icon(Icons.stacked_bar_chart),
          ),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTask()),
              );
            },
            label: Text(
              addButtonText,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
