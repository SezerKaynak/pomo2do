import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  File? temp;
  String? downloadUrl;

  @override
  void initState() {
    temp = image;
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
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

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    var user = users.doc(context.read<PomotodoUser>().userId);

    var title = "Profil Düzenleme";
    var subtitle = "Kişisel bilgilerinizi düzenleyebilirsiniz👋";
    var name = "Adınız";
    var surname = "Soyadınız";
    var birthday = "Doğum Tarihiniz";

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _surnameController = TextEditingController();
    final TextEditingController _birthdayController = TextEditingController();

    return WillPopScope(
      onWillPop: () async => isLoading ? false : true,
      child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
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
                          title: title,
                          theme: Theme.of(context).textTheme.headline4,
                          fontW: FontWeight.w600,
                          textPosition: TextAlign.left,
                          customPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        ),
                        ScreenTexts(
                            title: subtitle,
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
                            title: name,
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
                                  textLabel:
                                      "${asyncSnapshot.data.data()["name"]}",
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
                            builder: (BuildContext context,
                                AsyncSnapshot asyncSnapshot) {
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
                                  textLabel:
                                      "${asyncSnapshot.data.data()["surname"]}",
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
                            builder: (BuildContext context,
                                AsyncSnapshot asyncSnapshot) {
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
                                            TaskView()),
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

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.downloadUrl,
    required this.image,
  }) : super(key: key);

  final String? downloadUrl;
  final File? image;

  @override
  Widget build(BuildContext context) {
    if (downloadUrl == null && image == null) {
      return const CircleAvatar(
          radius: 80.0, backgroundImage: AssetImage("assets/person.png"));
    } else if (downloadUrl != null && image == null) {
      return CircleAvatar(
        radius: 80.0,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: downloadUrl!,
          imageBuilder: (context, imageProvider) {
            return ClipOval(
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(80),
                    child: Image(image: imageProvider, fit: BoxFit.cover)));
          },
          placeholder: (context, url) {
            return ClipOval(
                child: SizedBox.fromSize(
              size: const Size.fromRadius(20),
              child: const CircularProgressIndicator(color: Colors.white),
            ));
          },
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else if (downloadUrl == null && image != null) {
      return CircleAvatar(radius: 80.0, backgroundImage: FileImage(image!));
    }
    return CircleAvatar(radius: 80.0, backgroundImage: FileImage(image!));
  }
}
