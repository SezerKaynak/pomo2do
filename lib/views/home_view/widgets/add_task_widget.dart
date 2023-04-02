import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/select_icon_provider.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/home_view/home.view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTaskWidget> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskTypeController;
  late TextEditingController _taskInfoController;

  @override
  void initState() {
    _taskNameController = TextEditingController();
    _taskTypeController = TextEditingController();
    _taskInfoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskTypeController.dispose();
    _taskInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = L10n.of(context)!;
    DatabaseService dbService = DatabaseService();

    List<TaskModel>? tasks =
        Provider.of<TasksProvider>(context, listen: false).tasks;
    List<String> taskTypes = [];

    for (var element in tasks!) {
      !taskTypes.contains(element.taskType)
          ? taskTypes.add(element.taskType)
          : null;
    }

    final selectedIcon = Provider.of<SelectIcon>(context, listen: true);
    List<IconData> iconData = selectedIcon.icons;
    List<Widget> icons = [];
    for (int i = 0; i < iconData.length; i++) {
      icons.add(Icon(iconData[i]));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
          15, 0, 15, MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              widthFactor: 0.25,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                child: Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: Text(
                  l10n.addTask,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScreenTextField(
                      textLabel: l10n.taskPageTaskName,
                      controller: _taskNameController,
                      maxLines: 1),
                  Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      ScreenTextField(
                        textLabel: l10n.taskPageTaskType,
                        controller: _taskTypeController,
                        maxLines: 1,
                      ),
                      Visibility(
                        visible: taskTypes.isNotEmpty,
                        child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onSelected: (String value) {
                            setState(() {
                              _taskTypeController.text = value;
                            });
                          },
                          itemBuilder: (context) {
                            return taskTypes.map((String element) {
                              return PopupMenuItem(
                                  value: element, child: Text(element));
                            }).toList();
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                        ),
                      )
                    ],
                  ),
                  ScreenTextField(
                      textLabel: l10n.taskPageTaskInfo,
                      controller: _taskInfoController,
                      maxLines: 4),
                  RepaintBoundary(
                    child: ToggleButtons(
                      onPressed: (int index) {
                        selectedIcon.selectedIcon(index);
                      },
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * .12,
                          minHeight: MediaQuery.of(context).size.height * .06),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.blue[700],
                      selectedColor: Colors.white,
                      fillColor: Theme.of(context).primaryColor,
                      color: Colors.blue[400],
                      isSelected: selectedIcon.selectedWeather,
                      children: icons,
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () async {
                      TaskModel newTask = TaskModel();
                      newTask.taskType = _taskTypeController.text;
                      newTask.taskInfo = _taskInfoController.text;
                      newTask.taskIcon = selectedIcon.codePoint;
                      if (!tasks
                          .map((e) => e.taskName)
                          .contains(_taskNameController.text)) {
                        newTask.taskName = _taskNameController.text;
                        await dbService.addTask(newTask);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeView()));
                      } else {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: l10n.taskFound,
                            text: l10n.taskFoundDetailed,
                            confirmBtnText: l10n.confirmButtonText);
                      }
                    },
                    child: Text(l10n.buttonText),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
