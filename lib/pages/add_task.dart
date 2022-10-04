import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/task.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    var title = "Görev Ekleme Sayfası";
    var subtitle = "Görevin ismi,türü ve açıklamasını giriniz👋";
    var taskName = "Görev İsmi";
    var taskType = "Görev Türü";
    var taskInfo = "Görev Açıklaması";
    bool isDone = false;
    var textLabel2 = 'Ders Çalışılacak';
    var textLabel3 = 'Ev İşi';
    var textLabel4 = 'Matematik 20 soru çözülecek';

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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TaskView()),
                  ModalRoute.withName("/Task"));
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
                    obscure: true,
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
                          CollectionReference users = FirebaseFirestore.instance
                              .collection(
                                  'Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');

                          users.add({
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
                        child: const Text("Kaydet"))),
              ],
            ),
          ),
        ));
  }
}
