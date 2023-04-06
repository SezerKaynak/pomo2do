import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/core/service/database_service.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/home_view/home.view.dart';
import 'package:pomotodo/views/sign_in_view/widgets/sign_in_widget.dart';
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
    var l10n = L10n.of(context)!;
    List keyAndIndex = ModalRoute.of(context)!.settings.arguments as List;

    TaskModel selectedTask = Provider.of<TasksProvider>(context)
        .retrievedTaskList![keyAndIndex[0]]![keyAndIndex[1]];
    _taskNameController.text = selectedTask.taskName;
    _taskInfoController.text = selectedTask.taskInfo;
    _taskTypeController.text = selectedTask.taskType;
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
                  title: l10n.taskPageTitle,
                  theme: Theme.of(context).textTheme.headlineMedium,
                  fontW: FontWeight.w600,
                  textPosition: TextAlign.left,
                ),
                ScreenTexts(
                    title: l10n.taskPageSubtitle,
                    theme: Theme.of(context).textTheme.titleMedium,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: l10n.taskPageTaskName,
                    theme: Theme.of(context).textTheme.titleMedium,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(controller: _taskNameController, maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: l10n.taskPageTaskType,
                    theme: Theme.of(context).textTheme.titleMedium,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(controller: _taskTypeController, maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: l10n.taskPageTaskInfo,
                    theme: Theme.of(context).textTheme.titleMedium,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(controller: _taskInfoController, maxLines: 3),
                FormField(
                  initialValue: selectedTask.isDone,
                  builder: (FormFieldState state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text(l10n.isTaskDone),
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
                          title: Text(l10n.isTaskArchive),
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
                CustomElevatedButton(
                    onPressed: () async {
                      selectedTask.taskName = _taskNameController.text;
                      selectedTask.taskType = _taskTypeController.text;
                      selectedTask.taskInfo = _taskInfoController.text;
                      selectedTask.isDone = isCheckedDone;
                      selectedTask.isArchive = isCheckedArchive;
                      selectedTask.isActive = true;

                      await dbService.updateTask(selectedTask);

                      isCheckedDone && isCheckedArchive
                          ? SmartDialog.showToast(l10n.taskMovedIntoArchive)
                          : isCheckedDone
                              ? SmartDialog.showToast(
                                  l10n.taskMovedIntoCompleted)
                              : isCheckedArchive
                                  ? SmartDialog.showToast(
                                      l10n.taskMovedIntoArchive)
                                  : DoNothingAction();
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()),
                        ModalRoute.withName("/Task"),
                      );
                    },
                    child: Text(l10n.updateButtonText))
              ],
            ),
          ),
        ));
  }
}
