import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:provider/provider.dart';

class PersonInfo extends StatelessWidget with ProjectThemeOptions {
  PersonInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    var user = users.doc(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: ProjectThemeOptions().systemTheme,
        backgroundColor: ProjectThemeOptions().backGroundColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TaskView()),
                  ModalRoute.withName("/Task"));
            }),
      ),
      body: Column(
        children: [
          TaskAdded(
            title: StreamBuilder(
                stream: user.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  return Text(
                    "${asyncSnapshot.data.data()["name"]}"
                    " ${asyncSnapshot.data.data()["surname"]}",
                  );
                }),
            subtitle: "Profilinizi düzenleyebilirsiniz",
            onTouch: () {},
          ),
          TaskAdded(
            title: "Şifreyi Değiştir",
            subtitle: "Şifrenizi Değiştirebilirsiniz",
            onTouch: () {},
          ),
          TaskAdded(
            title: "Bildirim Ayarı",
            subtitle:
                "Bu kısımda almak istediğiniz bildirimleri seçebilirsiniz",
            onTouch: () {},
          ),
          TaskAdded(
            title: "Pomodoro Ayarı",
            subtitle:
                "Bu kısımda pomodoro ve ara dakikalarını,sayısını değiştirebilirsiniz",
            onTouch: () {},
          ),
          TaskAdded(
            title: const Text("Çıkış Yap"),
            subtitle: "Hesaptan çıkış yapın", onTouch: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
    );
  }
}
