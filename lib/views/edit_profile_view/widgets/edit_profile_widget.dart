import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/edit_profile_view/widgets/custom_avatar.dart';
import 'package:pomotodo/views/home_view/home.view.dart';
import 'package:pomotodo/views/sign_in_view/widgets/sign_in_widget.dart';
import 'package:provider/provider.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileWidget> {
  File? image;
  File? temp;
  String? downloadUrl;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _birthdayController;

  @override
  void initState() {
    temp = image;
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _birthdayController = TextEditingController();
    super.initState();
  }

  baglantiAl() async {
    String yol = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(context.read<PomotodoUser>().userId)
        .child("profilResmi.png")
        .getDownloadURL();

    setState(() {
      downloadUrl = yol;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    var user = users.doc(context.read<PomotodoUser>().userId);

    return WillPopScope(
      onWillPop: () async => isLoading ? false : true,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                !isLoading ? Navigator.pop(context) : DoNothingAction();
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                  height: 2,
                  child: Visibility(
                      visible: isLoading,
                      child: const LinearProgressIndicator(
                        color: Colors.red,
                      ))),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ScreenPadding()
                        .screenPadding
                        .copyWith(top: 8, left: 20, right: 20),
                    child: Column(
                      children: [
                        ScreenTexts(
                          title: editProfileTitle,
                          theme: Theme.of(context).textTheme.headline4,
                          fontW: FontWeight.w600,
                          textPosition: TextAlign.left,
                          customPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        ),
                        ScreenTexts(
                            title: editProfileSubtitle,
                            theme: Theme.of(context).textTheme.subtitle1,
                            fontW: FontWeight.w400,
                            textPosition: TextAlign.left,
                            customPadding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        const SizedBox(height: 25),
                        Center(
                          child: Stack(children: [
                            Avatar(downloadUrl: downloadUrl, image: image),
                            Positioned(
                                bottom: 20,
                                right: 25,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) => choose()));
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ))
                          ]),
                        ),
                        ScreenTexts(
                            title: editProfileName,
                            theme: Theme.of(context).textTheme.subtitle1,
                            fontW: FontWeight.w500,
                            textPosition: TextAlign.left),
                        StreamBuilder(
                            stream: user.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot asyncSnapshot) {
                              if (asyncSnapshot.hasError) {
                                return ScreenTextField(
                                  textLabel: "Something went wrong",
                                  controller: _nameController,
                                  maxLines: 1,
                                );
                              }

                              if (asyncSnapshot.connectionState ==
                                  ConnectionState.active) {
                                _nameController.text =
                                    asyncSnapshot.data.data()["name"];
                                return ScreenTextField(
                                  textLabel:
                                      "${asyncSnapshot.data.data()["name"]}",
                                  controller: _nameController,
                                  maxLines: 1,
                                );
                              }

                              return ScreenTextField(
                                textLabel: "Loading",
                                controller: _nameController,
                                maxLines: 1,
                              );
                            }),
                        const SizedBox(height: 20),
                        ScreenTexts(
                            title: editProfileSurname,
                            theme: Theme.of(context).textTheme.subtitle1,
                            fontW: FontWeight.w500,
                            textPosition: TextAlign.left),
                        StreamBuilder(
                            stream: user.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot asyncSnapshot) {
                              if (asyncSnapshot.hasError) {
                                return ScreenTextField(
                                  textLabel: "Something went wrong",
                                  controller: _surnameController,
                                  maxLines: 1,
                                );
                              }

                              if (asyncSnapshot.connectionState ==
                                  ConnectionState.active) {
                                _surnameController.text =
                                    asyncSnapshot.data.data()["surname"];
                                return ScreenTextField(
                                  textLabel:
                                      "${asyncSnapshot.data.data()["surname"]}",
                                  controller: _surnameController,
                                  maxLines: 1,
                                );
                              }

                              return ScreenTextField(
                                textLabel: "Loading",
                                controller: _surnameController,
                                maxLines: 1,
                              );
                            }),
                        const SizedBox(height: 20),
                        ScreenTexts(
                            title: editProfileBirthday,
                            theme: Theme.of(context).textTheme.subtitle1,
                            fontW: FontWeight.w500,
                            textPosition: TextAlign.left),
                        StreamBuilder(
                            stream: user.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot asyncSnapshot) {
                              if (asyncSnapshot.hasError) {
                                return ScreenTextField(
                                  textLabel: "Something went wrong",
                                  controller: _birthdayController,
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
                                        lastDate: DateTime(2100));

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd.MM.yyyy')
                                              .format(pickedDate);

                                      _birthdayController.text = formattedDate;
                                    } else {}
                                  },
                                  con: const Icon(Icons.calendar_today),
                                  textLabel:
                                      "${asyncSnapshot.data.data()["birthday"]}",
                                  controller: _birthdayController,
                                  maxLines: 1,
                                );
                              }

                              return ScreenTextField(
                                textLabel: "Loading",
                                controller: _birthdayController,
                                maxLines: 1,
                              );
                            }),
                        const SizedBox(height: 40),
                        SizedBox(
                            width: 400,
                            height: 60,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () async {
                                  CollectionReference users = FirebaseFirestore
                                      .instance
                                      .collection('Users');
                                  var user = users
                                      .doc(context.read<PomotodoUser>().userId);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  user.set({
                                    'name': _nameController.text,
                                    'surname': _surnameController.text,
                                    'birthday': _birthdayController.text,
                                    'email': context
                                        .read<PomotodoUser>()
                                        .userMail
                                        .toString(),
                                  });

                                  if (temp != image) {
                                    await uploadImage();
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                  //ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const HomeView()),
                                    ModalRoute.withName('/'),
                                  );
                                },
                                child: const Text("Güncelle"))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future uploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    await firebaseStorage
        .ref()
        .child("profilresimleri")
        .child(context.read<PomotodoUser>().userId)
        .child("profilResmi.png")
        .putFile(image!);
  }

  Future pickImage(ImageSource source) async {
    try {
      final pp = await ImagePicker().pickImage(source: source);
      if (pp == null) return;
      final imageTemporary = File(pp.path);

      setState(() {
        image = imageTemporary;
      });
    } on PlatformException catch (_) {
      SmartDialog.showToast("Resim seçilemedi!");
    }
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
