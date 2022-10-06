import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/service/firebase_service.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService repository = AuthService();
    var title = "Profil Düzenleme Sayfası";
    var subtitle = "Kişisel bilgilerinizi düzenleyebilirsiniz👋";
    var resim = "Profil Resminiz";
    var name = "Adınız";
    var surname = "Soyadınız";
    var birthday = "Doğum Tarihiniz";

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _surnameController = TextEditingController();
    final TextEditingController _birthdayController = TextEditingController();

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
                  MaterialPageRoute(builder: (context) => PersonInfo()),
                  ModalRoute.withName("/PersonInfo"));
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
                    title: name,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: _nameGet().toString(),
                    obscure: false,
                    controller: _nameController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: surname,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: surname,
                    obscure: true,
                    controller: _surnameController,
                    height: 70,
                    maxLines: 1),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: birthday,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                ScreenTextField(
                    textLabel: birthday,
                    obscure: false,
                    controller: _birthdayController,
                    height: 70,
                    maxLines: 1),
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
                          // var task = users.doc(id);

                          // task.set({
                          //   'taskName': _taskNameController.text,
                          //   'taskType': _taskTypeController.text,
                          //   'taskInfo': _taskInfoController.text,
                          //   "isDone": isDone,
                          // });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonInfo()),
                              ModalRoute.withName("/Task"));
                        },
                        child: const Text("Güncelle"))),
              ],
            ),
          ),
        ));
  }

  _nameGet() async {
    // CollectionReference users = FirebaseFirestore.instance.collection("Users");
    // var user = users.doc(FirebaseAuth.instance.currentUser!.uid);
    var document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print(document.data()!['name']);
    return Text(document.data()!['name']);
    // StreamBuilder(
    //     stream: user.snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
    //       return asyncSnapshot.data.data()["name"];
    //     });
  }
}
