import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/providers/list_update_provider.dart';
import 'package:flutter_application_1/providers/tasks_provider.dart';
import 'package:flutter_application_1/screens/archived_tasks.dart';
import 'package:flutter_application_1/screens/completed_tasks.dart';
import 'package:flutter_application_1/screens/deleted_tasks.dart';
import 'package:flutter_application_1/screens/deneme.dart';
import 'package:flutter_application_1/screens/edit_profile.dart';
import 'package:flutter_application_1/screens/edit_task.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_application_1/providers/dark_theme_provider.dart';
import 'package:flutter_application_1/service/firebase_service.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/auth_widget.dart';
import 'package:flutter_application_1/widgets/auth_widget_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  ThemeData theme, themeDark;
  WidgetsFlutterBinding.ensureInitialized();

  Future<ThemeData> loadTheme(String path) async {
    final themeStr = await rootBundle.loadString(path);
    final themeJson = jsonDecode(themeStr);
    final theme = ThemeDecoder.decodeThemeData(themeJson)!;
    return theme;
  }

  theme = await loadTheme("assets/appainter_theme.json");
  themeDark = await loadTheme("assets/appainter_theme_dark.json");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      const AndroidInitializationSettings("google");
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (context) => TasksProvider()),
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

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: AuthWidgetBuilder(
          onPageBuilder: (context, AsyncSnapshot<PomotodoUser?> snapShot) =>
              MaterialApp(
                  navigatorObservers: [FlutterSmartDialog.observer],
                  builder: FlutterSmartDialog.init(),
                  initialRoute: '/',
                  routes: {
                    '/task': (context) => TaskView(),
                    '/done': (context) => const CompletedTasks(),
                    '/editTask': (context) => const EditTask(),
                    '/deleted': (context) => ChangeNotifierProvider<ListUpdate>(
                        create: (context) => ListUpdate(),
                        child: const DeletedTasks()),
                    '/editProfile': (context) => const EditProfile(),
                    '/archived': (context) => const ArchivedTasks(),
                    '/deneme': (context) => const Deneme(),
                  },
                  debugShowCheckedModeBanner: false,
                  theme: context.watch<DarkThemeProvider>().darkTheme
                      ? widget.themeDark
                      : widget.theme,
                  home: AuthWidget(snapShot: snapShot))),
    );
  }
}
