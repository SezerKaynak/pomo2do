import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class EditTask extends StatefulWidget {
  const EditTask({
    super.key,
  });
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  bool isCheckedDone = false;
  bool isCheckedArchive = false;
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    TaskModel selectedTask =
        ModalRoute.of(context)!.settings.arguments as TaskModel;
    var title = "Görev Düzenleme Sayfası";
    var subtitle = "Görevin ismi,türü ve açıklamasını düzenleyebilirsiniz👋";
    var taskN = "Görev İsmi";
    var taskT = "Görev Türü";
    var taskI = "Görev Açıklaması";

    final TextEditingController _taskNameController = TextEditingController();
    final TextEditingController _taskTypeController = TextEditingController();
    final TextEditingController _taskInfoController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
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
                  title: title,
                  theme: Theme.of(context).textTheme.headline4,
                  fontW: FontWeight.w600,
                  textPosition: TextAlign.left,
                ),
                ScreenTexts(
                    title: subtitle,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: taskN,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskNameController.text = selectedTask.taskName,
                    obscure: false,
                    controller: _taskNameController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskT,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskTypeController.text = selectedTask.taskType,
                    obscure: false,
                    controller: _taskTypeController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskI,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskInfoController.text = selectedTask.taskInfo,
                    obscure: false,
                    controller: _taskInfoController,
                    height: 120,
                    maxLines: 3),
                FormField(
                  initialValue: selectedTask.isDone,
                  builder: (FormFieldState state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Görev tamamlandı mı?'),
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
                          title: const Text('Görev arşivlensin mi?'),
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
                              ? SmartDialog.showToast("Görev arşive taşındı!")
                              : isCheckedDone
                                  ? SmartDialog.showToast(
                                      "Görev tamamlanmış görevler sayfasına taşındı!")
                                  : isCheckedArchive
                                      ? SmartDialog.showToast(
                                          "Görev arşive taşındı!")
                                      : DoNothingAction();
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskView()),
                              ModalRoute.withName("/Task"));
                        },
                        child: const Text("Güncelle"))),
              ],
            ),
          ),
        ));
  }
}
