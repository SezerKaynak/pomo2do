import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/task_model.dart';
import 'package:flutter_application_1/core/providers/tasks_provider.dart';
import 'package:flutter_application_1/utils/constants/constants.dart';
import 'package:flutter_application_1/views/home_view/home.view.dart';
import 'package:flutter_application_1/core/service/database_service.dart';
import 'package:flutter_application_1/views/common/widgets/screen_text_field.dart';
import 'package:flutter_application_1/views/common/widgets/screen_texts.dart';
import 'package:flutter_application_1/views/signIn_view/widgets/sign_in_widget.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class EditTaskWidget extends StatefulWidget {
  const EditTaskWidget({
    super.key,
  });
  @override
  State<EditTaskWidget> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTaskWidget> {
  bool isCheckedDone = false;
  bool isCheckedArchive = false;
  DatabaseService dbService = DatabaseService();
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
    List keyAndIndex = ModalRoute.of(context)!.settings.arguments as List;

    TaskModel selectedTask = Provider.of<TasksProvider>(context)
        .retrievedTaskList![keyAndIndex[0]]![keyAndIndex[1]];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: ScreenPadding()
                .screenPadding
                .copyWith(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                ScreenTexts(
                  title: taskPageTitle,
                  theme: Theme.of(context).textTheme.headline4,
                  fontW: FontWeight.w600,
                  textPosition: TextAlign.left,
                ),
                ScreenTexts(
                    title: taskPageSubtitle,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: taskPageTaskName,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskNameController.text = selectedTask.taskName,
                    obscure: false,
                    controller: _taskNameController,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskPageTaskType,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskTypeController.text = selectedTask.taskType,
                    obscure: false,
                    controller: _taskTypeController,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskPageTaskInfo,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskInfoController.text = selectedTask.taskInfo,
                    obscure: false,
                    controller: _taskInfoController,
                    maxLines: 3),
                FormField(
                  initialValue: selectedTask.isDone,
                  builder: (FormFieldState state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: const Text(isTaskDone),
                          activeColor: Colors.blue,
                          value: state.value,
                          onChanged: (value) {
                            setState(() {
                              state.didChange(value);
                              isCheckedDone = state.value;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.platform,
                        ),
                      ],
                    );
                  },
                ),
                FormField(
                  initialValue: selectedTask.isArchive,
                  builder: (FormFieldState state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: const Text(isTaskArchive),
                          activeColor: Colors.blue,
                          value: state.value,
                          onChanged: (value) {
                            setState(() {
                              state.didChange(value);
                              isCheckedArchive = state.value;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.platform,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          selectedTask.taskName = _taskNameController.text;
                          selectedTask.taskType = _taskTypeController.text;
                          selectedTask.taskInfo = _taskInfoController.text;
                          selectedTask.isDone = isCheckedDone;
                          selectedTask.isArchive = isCheckedArchive;
                          selectedTask.isActive = true;
                          await dbService.updateTask(selectedTask);

                          isCheckedDone && isCheckedArchive
                              ? SmartDialog.showToast(taskMovedIntoArchive)
                              : isCheckedDone
                                  ? SmartDialog.showToast(
                                      taskMovedIntoCompleted)
                                  : isCheckedArchive
                                      ? SmartDialog.showToast(
                                          taskMovedIntoArchive)
                                      : DoNothingAction();
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()),
                              ModalRoute.withName("/Task"));
                        },
                        child: const Text(updateButtonText))),
              ],
            ),
          ),
        ));
  }
}
