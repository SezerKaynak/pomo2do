import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/providers/leaderboard_provider.dart';
import 'package:pomotodo/core/providers/list_update_provider.dart';
import 'package:pomotodo/core/providers/locale_provider.dart';
import 'package:pomotodo/core/providers/spotify_provider.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/core/service/notification_controller.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/archived_task_view/archived_task.view.dart';
import 'package:pomotodo/views/auth_view/auth_widget.dart';
import 'package:pomotodo/views/auth_view/auth_widget_builder.dart';
import 'package:pomotodo/views/completed_task_view/completed_task.view.dart';
import 'package:pomotodo/views/deleted_task_view/deleted_task.view.dart';
import 'package:pomotodo/views/leaderboard_view/leaderboard.view.dart';
import 'package:pomotodo/views/app_settings/app_settings.view.dart';
import 'package:pomotodo/views/pomodoro_settings_view/pomodoro_settings.view.dart';
import 'package:pomotodo/views/task_statistics/task_statistics.view.dart';
import 'package:pomotodo/views/edit_profile_view/edit_profile.view.dart';
import 'package:pomotodo/views/edit_task_view/edit_task.view.dart';
import 'package:pomotodo/views/home_view/home.view.dart';
import 'package:pomotodo/core/providers/dark_theme_provider.dart';
import 'package:pomotodo/core/service/firebase_service.dart';
import 'package:pomotodo/core/service/i_auth_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:alarm/alarm.dart';

import 'views/app_settings/app_settings.viewmodel.dart';

Future<void> main() async {
  ThemeData theme, themeDark;
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  Future<ThemeData> loadTheme(String path) async {
    final themeStr = await rootBundle.loadString(path);
    final themeJson = jsonDecode(themeStr);
    final theme = ThemeDecoder.decodeThemeData(themeJson)!;
    return theme;
  }

  await Alarm.init();

  theme = await loadTheme("assets/app_theme/appainter_theme.json");
  themeDark = await loadTheme("assets/app_theme/appainter_theme_dark.json");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationController.initializeLocalNotifications();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (context) => SpotifyProvider()),
        Provider.value(value: await SharedPreferences.getInstance()),
      ],
      child: MyApp(theme: theme, themeDark: themeDark),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.theme, required this.themeDark})
      : super(key: key);
  final ThemeData theme;
  final ThemeData themeDark;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  LocaleModel languageProvider = LocaleModel();
  AppSettingsController notificationSettingsController =
      AppSettingsController();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getCurrentAppLanguage();
    getCurrentNotificationSettings();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void getCurrentAppLanguage() async {
    String languageCode = await languageProvider.languagePreference
        .getLocale()
        .then((value) => value[0]);
    String countryCode = await languageProvider.languagePreference
        .getLocale()
        .then((value) => value[1]);
    languageProvider.locale = Locale(languageCode, countryCode);
  }

  void getCurrentNotificationSettings() async {
    notificationSettingsController.alarmSetting =
        await notificationSettingsController.notificationSettingsPreference
            .getSetting()
            .then((value) => value[0]);
    notificationSettingsController.notificationSetting =
        await notificationSettingsController.notificationSettingsPreference
            .getSetting()
            .then((value) => value[1]);
    notificationSettingsController.warnSetting =
        await notificationSettingsController.notificationSettingsPreference
            .getSetting()
            .then((value) => value[2]);
    notificationSettingsController.spotifySetting =
        await notificationSettingsController.notificationSettingsPreference
            .getSetting()
            .then((value) => value[3]);
    notificationSettingsController.pauseSpotifySetting =
        await notificationSettingsController.notificationSettingsPreference
            .getSetting()
            .then((value) => value[4]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => languageProvider),
        ChangeNotifierProvider(create: (context) => themeChangeProvider),
        ChangeNotifierProvider(
            create: (context) => notificationSettingsController)
      ],
      child: AuthWidgetBuilder(
        onPageBuilder: (context, AsyncSnapshot<PomotodoUser?> snapShot) =>
            MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          navigatorObservers: [FlutterSmartDialog.observer],
          supportedLocales: L10n.supportedLocales,
          locale: context.watch<LocaleModel>().locale,
          builder: FlutterSmartDialog.init(),
          initialRoute: '/',
          routes: {
            '/task': (context) => const HomeView(),
            '/done': (context) => const CompletedTasksView(),
            '/editTask': (context) => const EditTaskView(),
            '/deleted': (context) => ChangeNotifierProvider<ListUpdate>(
                  create: (context) => ListUpdate(),
                  child: const DeletedTasksView(),
                ),
            '/editProfile': (context) => const EditProfileView(),
            '/archived': (context) => const ArchivedTasksView(),
            '/pomodoroSettings': (context) => const PomodoroSettingsView(),
            '/notificationSettings': (context) => const AppSettingsView(),
            '/taskStatistics': (context) => ChangeNotifierProvider(
                  create: (context) => TaskStatsProvider(),
                  child: const TaskStatisticsView(),
                ),
            '/leaderboard': (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => LeaderboardProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => TaskStatsProvider(),
                    )
                  ],
                  child: const LeaderboardView(),
                ),
          },
          debugShowCheckedModeBanner: false,
          theme: context.watch<DarkThemeProvider>().darkTheme
              ? widget.themeDark
              : widget.theme,
          home: AuthWidget(snapShot: snapShot),
        ),
      ),
    );
  }
}
