import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/providers/dark_theme_provider.dart';
import 'package:pomotodo/core/providers/drawer_image_provider.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/edit_password_view/edit_password.view.dart';
import 'package:pomotodo/core/service/firebase_service.dart';
import 'package:pomotodo/views/home_view/widgets/custom_switch.dart';
import 'package:pomotodo/views/home_view/widgets/settings.dart' as settings;
import 'package:pomotodo/views/pomodoro_settings_view/pomodoro_settings.view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthService _authService = AuthService();
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  late DrawerImageProvider drawerImageProvider;

  @override
  void initState() {
    super.initState();
    drawerImageProvider =
        Provider.of<DrawerImageProvider>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => drawerImageProvider.getURL(context));
  }

  @override
  Widget build(BuildContext context) {
    var user = users.doc(context.read<PomotodoUser>().userId);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.745,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: const DecorationImage(
                image: AssetImage("assets/images/header.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  child: Consumer<DrawerImageProvider>(
                    builder: (context, value, child) {
                      return drawerImageProvider.downloadUrl != null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: drawerImageProvider.downloadUrl!,
                              imageBuilder: (context, imageProvider) {
                                return ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(50),
                                    child: Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                );
                              },
                              placeholder: (context, url) {
                                return ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(20),
                                    child: const CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(70),
                                child: Image.asset(
                                  'assets/images/person.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                    },
                  ),
                ),
                StreamBuilder(
                    stream: user.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        return const Text("Bir şeyler yanlış gitti");
                      } else if (asyncSnapshot.hasData &&
                          !asyncSnapshot.data!.exists) {
                        return const Text(
                          "Hesap ayarları sayfasından profil resmi seçebilirsiniz",
                          overflow: TextOverflow.clip,
                          maxLines: 3,
                        );
                      } else if (asyncSnapshot.connectionState ==
                          ConnectionState.active) {
                        return Text(
                          "${asyncSnapshot.data.data()["name"]}"
                          " ${asyncSnapshot.data.data()["surname"]}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.normal),
                        );
                      }
                      return const Text("Loading");
                    }),
              ],
            ),
          ),
          settings.Settings(
            settingIcon: Icons.account_circle,
            title: settingTitle(context, "Hesap Ayarları"),
            subtitle: "Profilinizi düzenleyebilirsiniz.",
            tap: () {
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
          const Divider(thickness: 1),
          settings.Settings(
            settingIcon: Icons.password,
            subtitle: "Şifrenizi değiştirebilirsiniz.",
            title: settingTitle(context, 'Şifreyi Değiştir'),
            tap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditPasswordView()));
            },
          ),
          const Divider(thickness: 1),
          settings.Settings(
              settingIcon: Icons.notifications,
              subtitle: "Bildirim ayarlarını yapabilirsiniz.",
              title: settingTitle(context, 'Bildirim Ayarları'),
              tap: () {}),
          const Divider(thickness: 1),
          settings.Settings(
              settingIcon: Icons.watch,
              subtitle: "Pomodoro sayacı vb. ayarları yapabilirsiniz.",
              title: settingTitle(context, 'Pomodoro Ayarları'),
              tap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PomodoroSettingsView()));
              }),
          const Divider(thickness: 1),
          settings.Settings(
              settingIcon: Icons.logout,
              subtitle: "Hesaptan çıkış yapın.",
              title: settingTitle(context, 'Çıkış Yap'),
              tap: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: alertTitleLogOut,
                  text: alertSubtitleLogOut,
                  confirmBtnText: alertApprove,
                  cancelBtnText: alertReject,
                  confirmBtnColor: Theme.of(context).errorColor,
                  onConfirmBtnTap: () async => await _authService.signOut(),
                  onCancelBtnTap: () => Navigator.of(context).pop(false),
                );
              }),
          const Divider(thickness: 1),
          CustomSwitch(
            switchValue: themeChange.darkTheme,
            switchOnChanged: (bool? value) {
              themeChange.darkTheme = value!;
            },
          )
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
