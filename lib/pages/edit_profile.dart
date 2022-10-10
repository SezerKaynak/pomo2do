import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({
    super.key,
    required this.email,
  });
  final String email;

  @override
  Widget build(BuildContext context) {
    var title = "Profil Düzenleme Sayfası";
    var subtitle = "Kişisel bilgilerinizi düzenleyebilirsiniz👋";
    var resim = "Profil Resminiz";
    var name = "Adınız";
    var surname = "Soyadınız";
    var birthday = "Doğum Tarihiniz";

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _surnameController = TextEditingController();
    final TextEditingController _birthdayController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    var user = users.doc(FirebaseAuth.instance.currentUser!.uid);
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
                    title: name,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                StreamBuilder(
                    stream: user.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        return ScreenTextField(
                          textLabel: "Something went wrong",
                          obscure: false,
                          controller: _nameController,
                          height: 70,
                          maxLines: 1,
                        );
                      }

                      if (asyncSnapshot.connectionState ==
                          ConnectionState.active) {
                        _nameController.text =
                            asyncSnapshot.data.data()["name"];
                        return ScreenTextField(
                          textLabel: "${asyncSnapshot.data.data()["name"]}",
                          obscure: false,
                          controller: _nameController,
                          height: 70,
                          maxLines: 1,
                        );
                      }

                      return ScreenTextField(
                        textLabel: "Loading",
                        obscure: false,
                        controller: _nameController,
                        height: 70,
                        maxLines: 1,
                      );
                    }),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: surname,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                StreamBuilder(
                    stream: user.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        return ScreenTextField(
                          textLabel: "Something went wrong",
                          obscure: false,
                          controller: _surnameController,
                          height: 70,
                          maxLines: 1,
                        );
                      }

                      if (asyncSnapshot.connectionState ==
                          ConnectionState.active) {
                        _surnameController.text =
                            asyncSnapshot.data.data()["surname"];
                        return ScreenTextField(
                          textLabel: "${asyncSnapshot.data.data()["surname"]}",
                          obscure: false,
                          controller: _surnameController,
                          height: 70,
                          maxLines: 1,
                        );
                      }

                      return ScreenTextField(
                        textLabel: "Loading",
                        obscure: false,
                        controller: _surnameController,
                        height: 70,
                        maxLines: 1,
                      );
                    }),
                const SizedBox(height: 20),
                ScreenTexts(
                    title: birthday,
                    theme: Theme.of(context).textTheme.subtitle1,
                    fontW: FontWeight.w500,
                    textPosition: TextAlign.left),
                StreamBuilder(
                    stream: user.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        return ScreenTextField(
                          textLabel: "Something went wrong",
                          obscure: false,
                          controller: _birthdayController,
                          height: 70,
                          maxLines: 1,
                        );
                      }

                      if (asyncSnapshot.connectionState ==
                          ConnectionState.active) {
                        _birthdayController.text =
                            asyncSnapshot.data.data()["birthday"];
                        return ScreenTextField(
                          textFieldInputType: TextInputType.none,
                          onTouch: () async {

                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd.MM.yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16

                              _birthdayController.text =
                                  formattedDate; //set output date to TextField value.

                            } else {}
                          },
                          con: const Icon(Icons.calendar_today),
                          textLabel: "${asyncSnapshot.data.data()["birthday"]}",
                          obscure: false,
                          controller: _birthdayController,
                          height: 70,
                          maxLines: 1,
                        );
                      }

                      return ScreenTextField(
                        textLabel: "Loading",
                        obscure: false,
                        controller: _birthdayController,
                        height: 70,
                        maxLines: 1,
                      );
                    }),
                const SizedBox(height: 50),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          CollectionReference users =
                              FirebaseFirestore.instance.collection('Users');
                          var user =
                              users.doc(FirebaseAuth.instance.currentUser!.uid);

                          user.set({
                            'name': _nameController.text,
                            'surname': _surnameController.text,
                            'birthday': _birthdayController.text,
                            'email': email,
                          });
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
}
