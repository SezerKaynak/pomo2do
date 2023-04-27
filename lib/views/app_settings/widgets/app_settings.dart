import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/dark_theme_provider.dart';
import 'package:pomotodo/core/providers/locale_provider.dart';
import 'package:pomotodo/core/providers/select_icon_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/app_settings/app_settings.viewmodel.dart';
import 'package:pomotodo/views/app_settings/widgets/setting.dart';
import 'package:provider/provider.dart';

class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  @override
  State<AppSettingsWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  List<Widget> alarmSettings = const [
    Icon(Icons.alarm_on),
    Icon(Icons.alarm_off),
  ];
  List<bool> selectedAlarmSetting = [true, false];
  late AppSettingsController notificationController;
  late LocaleModel localeProvider;
  late DarkThemeProvider themeChange;

  @override
  void initState() {
    notificationController =
        Provider.of<AppSettingsController>(context, listen: false);
    localeProvider = Provider.of<LocaleModel>(context, listen: false);
    themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SelectTheme selectedThemeIcon = SelectTheme();
    selectedThemeIcon.selectedTheme = [
      !themeChange.darkTheme,
      themeChange.darkTheme
    ];
    List<IconData> iconData = selectedThemeIcon.icons;
    List<Widget> themeIcons = [];
    for (int i = 0; i < iconData.length; i++) {
      themeIcons.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            Icon(iconData[i]),
            i == 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(L10n.of(context)!.lightMode),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(L10n.of(context)!.darkMode),
                  )
          ],
        ),
      ));
    }

    SelectLanguage selectedLanguage = SelectLanguage();
    selectedLanguage.selectedLanguage = [
      localeProvider.locale == const Locale('tr', 'TR') ? true : false,
      localeProvider.locale == const Locale('en', 'US') ? true : false,
    ];
    return Padding(
      padding: ScreenPadding.screenPadding.copyWith(top: 20),
      child: Column(
        children: [
          ScreenTexts(
            title: L10n.of(context)!.appSettings,
            theme: Theme.of(context).textTheme.headlineMedium,
            fontW: FontWeight.w600,
            textPosition: TextAlign.left,
          ),
          ScreenTexts(
            title: L10n.of(context)!.appSettingsSubtitle,
            theme: Theme.of(context).textTheme.titleMedium,
            fontW: FontWeight.w400,
            textPosition: TextAlign.left,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer<AppSettingsController>(
                  builder: (context, alarmValue, child) {
                    return Setting(
                      settingTitle: L10n.of(context)!.setAlarm,
                      settingValue: alarmValue,
                      settingType: 'Alarm',
                    );
                  },
                ),
                Consumer<AppSettingsController>(
                  builder: (context, notificationValue, child) {
                    return Setting(
                      settingTitle: L10n.of(context)!.setNotification,
                      settingValue: notificationValue,
                      settingType: 'Notification',
                    );
                  },
                ),
                Consumer<AppSettingsController>(
                  builder: (context, warningValue, child) {
                    return Setting(
                      settingTitle: L10n.of(context)!.resetPomodoroWarn,
                      settingValue: warningValue,
                      settingType: "Warning",
                    );
                  },
                ),
                Consumer<AppSettingsController>(
                  builder: (context, spotifyPlayerValue, child) {
                    return Setting(
                      settingTitle: L10n.of(context)!.spotifyPlayer,
                      settingValue: spotifyPlayerValue,
                      settingType: "Spotify",
                    );
                  },
                ),
                Consumer<AppSettingsController>(
                  builder: (context, pauseSpotifyValue, child) {
                    return Setting(
                      settingTitle: L10n.of(context)!.stopMusic,
                      settingValue: pauseSpotifyValue,
                      settingType: "PauseSpotify",
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(L10n.of(context)!.themePreference),
                    ToggleButtons(
                      onPressed: (int index) {
                        themeChange.darkTheme = index == 0 ? false : true;
                      },
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * .12,
                          minHeight: MediaQuery.of(context).size.height * .05),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                    Text(L10n.of(context)!.languagePreference),
                    ToggleButtons(
                      onPressed: (int index) {
                        localeProvider.locale == const Locale('en', 'US')
                            ? localeProvider.locale = const Locale('tr', 'TR')
                            : localeProvider.locale = const Locale('en', 'US');
                      },
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * .2,
                          minHeight: MediaQuery.of(context).size.height * .05),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.blue[700],
                      selectedColor: Colors.white,
                      fillColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      isSelected: selectedLanguage.selectedLanguage,
                      children: selectedLanguage.flags,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
