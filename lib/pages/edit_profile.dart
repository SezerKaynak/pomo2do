import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/service/firebase_service.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  String? downloadUrl;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
    super.initState();
  }

  baglantiAl() async {
    String yol = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("profilResmi.png")
        .getDownloadURL();

    setState(() {
      downloadUrl = yol;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
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
              color: Colors.white,
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
                Center(
                  child: Stack(children: [
                    Avatar(downloadUrl: downloadUrl, image: image),
                    Positioned(
                        bottom: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: ((builder) => choose()));
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.teal,
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
                            'email': FirebaseAuth.instance.currentUser!.email
                                .toString(),
                          });
                          uploadImage();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PersonInfo()),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: const Text("Güncelle"))),
              ],
            ),
          ),
        ));
  }

  void uploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    var ss = firebaseStorage
        .ref()
        .child("profilresimleri")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("profilResmi.png")
        .putFile(image!);
  }

  Future pickImage(ImageSource source) async {
    try {
      final pp = await ImagePicker().pickImage(source: source);
      if (pp == null) return;
      final imageTemporary = File(pp.path);
      //final imagePermanent = await saveImagePermanently(pp.path);
      print(pp.path);
      setState(() {
        image = imageTemporary;
      });
      print(image);
    } on PlatformException catch (e) {
      print("Failed to pick image:$e");
    }
  }

  // Future<File> saveImagePermanently(String imagePath) async {
  //   final pp = File('//storage/emulated/0/DCIM/profile.png');
  //   final name = basename(imagePath);
  //   print(pp);
  //   return File(imagePath).copy('//storage/emulated/0/DCIM/$name');
  // }

  // Future<Image> loadImagePermanently(String imagePath) async {
  //   final image = File('//storage/emulated/0/DCIM/profile.png');
  //   return Image.file(image);
  // }

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
              child: const CircularProgressIndicator(color: Colors.red),
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
