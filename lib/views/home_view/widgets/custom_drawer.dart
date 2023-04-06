import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/providers/dark_theme_provider.dart';
import 'package:pomotodo/core/providers/drawer_image_provider.dart';
import 'package:pomotodo/core/providers/locale_provider.dart';
import 'package:pomotodo/core/providers/select_icon_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/edit_password_view/edit_password.view.dart';
import 'package:pomotodo/core/service/firebase_service.dart';
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
  late LocaleModel localeProvider;
  late DarkThemeProvider themeChange;
  @override
  void initState() {
    super.initState();
    themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    drawerImageProvider =
        Provider.of<DrawerImageProvider>(context, listen: false);
    localeProvider = Provider.of<LocaleModel>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => drawerImageProvider.getURL(context, null));
  }

  @override
  Widget build(BuildContext context) {
    var user = users.doc(context.read<PomotodoUser>().userId);

    SelectTheme selectedThemeIcon = SelectTheme();
    selectedThemeIcon.selectedTheme = [
      !themeChange.darkTheme,
      themeChange.darkTheme
    ];
    List<IconData> iconData = selectedThemeIcon.icons;
    List<Widget> themeIcons = [];
    for (int i = 0; i < iconData.length; i++) {
      themeIcons.add(Icon(iconData[i]));
    }

    SelectLanguage selectedLanguage = SelectLanguage();
    selectedLanguage.selectedLanguage = [
      localeProvider.locale == const Locale('tr', 'TR') ? true : false,
      localeProvider.locale == const Locale('en', 'US') ? true : false,
    ];

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
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
                        return Text(L10n.of(context)!.somethingWrong);
                      } else if (asyncSnapshot.hasData &&
                          !asyncSnapshot.data!.exists) {
                        return Text(
                          L10n.of(context)!.uSelectPic,
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
                      return Text(L10n.of(context)!.loading);
                    }),
              ],
            ),
          ),
          settings.Settings(
            settingIcon: Icons.account_circle,
            title: settingTitle(context, L10n.of(context)!.accSettings),
            subtitle: L10n.of(context)!.uEditProfile,
            tap: () {
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
          const Divider(thickness: 1),
          Visibility(
            visible: !context.read<PomotodoUser>().loginProviderData!,
            child: Column(
              children: [
                settings.Settings(
                  settingIcon: Icons.password,
                  subtitle: L10n.of(context)!.uChangePassword,
                  title:
                      settingTitle(context, L10n.of(context)!.changePassword),
                  tap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditPasswordView()));
                  },
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
          settings.Settings(
              settingIcon: Icons.notifications,
              subtitle: L10n.of(context)!.uEditNotification,
              title:
                  settingTitle(context, L10n.of(context)!.notificationSettings),
              tap: () {}),
          const Divider(thickness: 1),
          settings.Settings(
              settingIcon: Icons.timer,
              subtitle: L10n.of(context)!.uEditPomodoro,
              title: settingTitle(context, L10n.of(context)!.pomodoroTitle),
              tap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PomodoroSettingsView()));
              }),
          const Divider(thickness: 1),
          settings.Settings(
            settingIcon: Icons.logout_outlined,
            subtitle: L10n.of(context)!.logOutAcc,
            title: settingTitle(context, L10n.of(context)!.logOut),
            tap: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: L10n.of(context)!.alertTitleLogOut,
                text: L10n.of(context)!.alertSubtitleLogOut,
                confirmBtnText: L10n.of(context)!.alertApprove,
                cancelBtnText: L10n.of(context)!.alertReject,
                confirmBtnColor: Theme.of(context).colorScheme.error,
                onConfirmBtnTap: () async => await _authService.signOut(),
                onCancelBtnTap: () => Navigator.of(context).pop(false),
              );
            },
          ),
          const Divider(thickness: 1),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      settingTitle(
                        context,
                        L10n.of(context)!.themePreference,
                      ),
                      ToggleButtons(
                        onPressed: (int index) {
                          themeChange.darkTheme = index == 0 ? false : true;
                        },
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * .12,
                            minHeight:
                                MediaQuery.of(context).size.height * .06),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.blue[700],
                        selectedColor: Colors.white,
                        fillColor: Theme.of(context).primaryColor,
                        color: Colors.blue[400],
                        isSelected: selectedThemeIcon.selectedTheme,
                        children: themeIcons,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      settingTitle(
                        context,
                        L10n.of(context)!.languagePreference,
                      ),
                      ToggleButtons(
                        onPressed: (int index) {
                          localeProvider.locale == const Locale('en', 'US')
                              ? localeProvider.locale = const Locale('tr', 'TR')
                              : localeProvider.locale =
                                  const Locale('en', 'US');
                        },
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * .12,
                            minHeight:
                                MediaQuery.of(context).size.height * .06),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.blue[700],
                        selectedColor: Colors.white,
                        fillColor: Theme.of(context).primaryColor,
                        color: Colors.blue[400],
                        isSelected: selectedLanguage.selectedLanguage,
                        children: selectedLanguage.flags,
                      ),
                    ],
                  ),
                ],
              ),
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
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w400, fontSize: 18),
      );
}
