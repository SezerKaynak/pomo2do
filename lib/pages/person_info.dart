import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/pages/edit_password.dart';
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
    var _authService = Provider.of<IAuthService>(context, listen: false);
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
            flex: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 50.0,
                  child: downloadUrl != null
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: downloadUrl!,
                          imageBuilder: (context, imageProvider) {
                            return ClipOval(
                                child: SizedBox.fromSize(
                                    size: const Size.fromRadius(50),
                                    child: Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover)));
                          },
                          placeholder: (context, url) {
                            return ClipOval(
                                child: SizedBox.fromSize(
                              size: const Size.fromRadius(20),
                              child: const CircularProgressIndicator(
                                  color: Colors.white),
                            ));
                          },
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(70),
                            child: Image.asset(
                              'assets/person.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: StreamBuilder(
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
                            return Text(
                              "${asyncSnapshot.data.data()["name"]}"
                              " ${asyncSnapshot.data.data()["surname"]}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400, fontSize: 26),
                            );
                          }
                          return const Text("Loading");
                        }),
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [Column(
                  children: [
                    const Divider(thickness: 1),
                    Settings(
                      settingIcon: Icons.account_circle,
                      title: settingTitle(context, "Hesap Ayarları"),
                      subtitle: "Profilinizi düzenleyebilirsiniz.",
                      tap: () {
                        Navigator.pushNamed(context, '/editProfile');
                      },
                    ),
                    const Divider(thickness: 1),
                    Settings(
                      settingIcon: Icons.password,
                      subtitle: "Şifrenizi değiştirebilirsiniz.",
                      title: settingTitle(context, 'Şifreyi Değiştir'),
                      tap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditPassword()));
                      },
                    ),
                    const Divider(thickness: 1),
                    Settings(
                        settingIcon: Icons.notifications,
                        subtitle: "Bildirim ayarlarını yapabilirsiniz.",
                        title: settingTitle(context, 'Bildirim Ayarları'),
                        tap: () {}),
                    const Divider(thickness: 1),
                    Settings(
                        settingIcon: Icons.watch,
                        subtitle: "Pomodoro sayacı vb. ayarları yapabilirsiniz.",
                        title: settingTitle(context, 'Pomodoro Ayarları'),
                        tap: () {}),
                    const Divider(thickness: 1),
                    Settings(
                        settingIcon: Icons.logout,
                        subtitle: "Hesaptan çıkış yapın.",
                        title: settingTitle(context, 'Çıkış Yap'),
                        tap: () async {
                          await _authService.signOut();
                        }),
                    const Divider(thickness: 1),
                  ],
              ),]
            ),
          ),
        ],
      ),
    );
  }

  Text settingTitle(BuildContext context, String textTitle) => Text(
        textTitle,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.w400, fontSize: 18),
      );
}

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
    required this.settingIcon,
    required this.subtitle,
    required this.title,
    required this.tap,
  }) : super(key: key);

  final IconData settingIcon;
  final String subtitle;
  final Widget title;
  final Function() tap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              settingIcon,
              size: 40,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [title, const Icon(Icons.arrow_right_sharp)],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
