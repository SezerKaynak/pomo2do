import 'package:flutter/material.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/deleted_task_view/deleted_task.widgets.dart';

class DeletedTasksView extends StatelessWidget with DeletedTasksWidgets {
  const DeletedTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(L10n.of(context)!.trash),
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
