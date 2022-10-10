import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/task.dart';

class EditTask extends StatelessWidget {
  const EditTask({
    super.key,
    required this.taskName,
    required this.taskType,
    required this.taskInfo,
    required this.isDone,
    required this.id,
  });
  final String taskName;
  final String taskType;
  final String taskInfo;
  final bool isDone;
  final String id;

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black,
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
                    title: taskN,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _taskNameController.text = taskName,
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
                    textLabel: _taskTypeController.text = taskType,
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
                    textLabel: _taskInfoController.text = taskInfo,
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
                          CollectionReference users = FirebaseFirestore.instance
                              .collection(
                                  'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
                          var task = users.doc(id);

                          task.set({
                            'taskNameCaseInsensitive':
                                _taskNameController.text.toLowerCase(),
                            'taskName': _taskNameController.text,
                            'taskType': _taskTypeController.text,
                            'taskInfo': _taskInfoController.text,
                            "isDone": isDone,
                          });
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
