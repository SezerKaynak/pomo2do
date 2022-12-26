import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/providers/select_icon_provider.dart';
import 'package:flutter_application_1/utils/constants/constants.dart';
import 'package:flutter_application_1/views/home_view/widgets/add_task_widget.dart';
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
            heroTag: "btn1",
            onPressed: () {
              Navigator.pushNamed(context, '/deneme');
            },
            child: const Icon(Icons.stacked_bar_chart),
          ),
          FloatingActionButton.extended(
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
            label: Text(addButtonText,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Theme.of(context).cardColor)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
