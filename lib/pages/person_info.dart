import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/edit_password.dart';
import 'package:flutter_application_1/pages/edit_profile.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:provider/provider.dart';

class PersonInfo extends StatefulWidget with ProjectThemeOptions {
  PersonInfo({super.key});

  @override
  State<PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: ProjectThemeOptions().systemTheme,
        backgroundColor: ProjectThemeOptions().backGroundColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: downloadUrl != null
                    ? NetworkImage(downloadUrl!) as ImageProvider
                    : const AssetImage("assets/person.png"),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: [
                TaskAdded(
                  title: StreamBuilder(
                      stream: user.snapshots(),
                      builder:
                          (BuildContext context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (asyncSnapshot.hasData &&
                            !asyncSnapshot.data!.exists) {
                          return const Text("Document does not exist");
                        }

                        if (asyncSnapshot.connectionState ==
                            ConnectionState.active) {
                          return Text("${asyncSnapshot.data.data()["name"]}"
                              " ${asyncSnapshot.data.data()["surname"]}");
                        }
                        return const Text("Loading");
                      }),
                  subtitle: "Profilinizi düzenleyebilirsiniz",
                  onTouch: () {
                    Navigator.pushNamed(
                        context,
                        '/editProfile');
                  },
                ),
                TaskAdded(
                  title: const Text("Şifreyi Değiştir"),
                  subtitle: "Şifrenizi Değiştirebilirsiniz",
                  onTouch: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditPassword()));
                  },
                ),
                TaskAdded(
                  title: const Text("Bildirim Ayarı"),
                  subtitle:
                      "Bu kısımda almak istediğiniz bildirimleri seçebilirsiniz",
                  onTouch: () {},
                ),
                TaskAdded(
                  title: const Text("Pomodoro Ayarı"),
                  subtitle:
                      "Bu kısımda pomodoro ve ara dakikalarını,sayısını değiştirebilirsiniz",
                  onTouch: () {},
                ),
                TaskAdded(
                  title: const Text("Çıkış Yap"),
                  subtitle: "Hesaptan çıkış yapın",
                  onTouch: () async {
                    await _authService.signOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
