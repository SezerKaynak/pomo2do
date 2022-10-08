import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/service/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({
    super.key,
    required this.email,
  });
  final String email;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");

    var user = users.doc(FirebaseAuth.instance.currentUser!.uid);
    var title = "Profil Düzenleme Sayfası";
    var subtitle = "Kişisel bilgilerinizi düzenleyebilirsiniz👋";
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
                const Bottom(),
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
                          onTouch: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to Bottom before today.
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

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
      FirebaseStorage storage = FirebaseStorage.instance;
      var snapshot = storage
          .ref()
          .child("profilresimleri")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("profilResmi.png")
          .putFile(imagePermanent);
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: image != null
              ? FileImage(image!) as ImageProvider
              : const AssetImage("assets/person.png"),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => choose()));
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28,
              ),
            ))
      ]),
    );
  }

  Widget choose() {
    return Container(
      height: 100,
      //width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text("Profil Resmi Seçin", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text("Kamera"),
                onPressed: () => pickImage(ImageSource.camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Galeri"),
                onPressed: () => pickImage(ImageSource.gallery),
              )
            ],
          )
        ],
      ),
    );
  }
}
