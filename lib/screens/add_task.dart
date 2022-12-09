import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    var title = "Ne üzerine çalışıyorsunuz?";
    var subtitle = "Görevin ismi,türü ve açıklamasını giriniz👋";
    var taskName = "Görev İsmi";
    var taskType = "Görev Türü";
    var taskInfo = "Görev Açıklaması";
    var textLabel2 = 'Ders Çalışılacak';
    var textLabel3 = 'Ev İşi';
    var textLabel4 = 'Matematik 20 soru çözülecek';
    var buttonText = "Kaydet";

    final TextEditingController _taskNameController = TextEditingController();
    final TextEditingController _taskTypeController = TextEditingController();
    final TextEditingController _taskInfoController = TextEditingController();
    DatabaseService dbService = DatabaseService();

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
            padding: ScreenPadding().screenPadding,
            child: Column(
              children: [
                ScreenTexts(
                    title: title,
                    theme: Theme.of(context).textTheme.headline4,
                    fontW: FontWeight.w600,
                    textPosition: TextAlign.left),
                ScreenTexts(
                    title: subtitle,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w400,
                    textPosition: TextAlign.left),
                const SizedBox(height: 40),
                ScreenTexts(
                    title: taskName,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: textLabel2,
                    obscure: false,
                    controller: _taskNameController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskType,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: textLabel3,
                    obscure: false,
                    controller: _taskTypeController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: taskInfo,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: textLabel4,
                    obscure: false,
                    controller: _taskInfoController,
                    height: 120,
                    maxLines: 3),
                const SizedBox(height: 50),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          TaskModel newTask = TaskModel();
                          newTask.taskName = _taskNameController.text;
                          newTask.taskType = _taskTypeController.text;
                          newTask.taskInfo = _taskInfoController.text;
                          await dbService.addTask(newTask);

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskView()));
                        },
                        child: Text(buttonText))),
              ],
            ),
          ),
        ));
  }
}
