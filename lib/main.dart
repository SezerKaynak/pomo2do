import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/pages/archived_tasks.dart';
import 'package:flutter_application_1/pages/completed_tasks.dart';
import 'package:flutter_application_1/pages/deleted_tasks.dart';
import 'package:flutter_application_1/pages/deneme.dart';
import 'package:flutter_application_1/pages/edit_profile.dart';
import 'package:flutter_application_1/pages/edit_task.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_application_1/project_theme_options.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString("assets/appainter_theme.json");
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  
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
        Provider.value(value: await SharedPreferences.getInstance()),
      ],
      child: MyApp(theme: theme),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.theme}) : super(key: key);
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return AuthWidgetBuilder(
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
              // theme: ThemeData().copyWith(
              //   appBarTheme: AppBarTheme(
              //     backgroundColor: ProjectThemeOptions().backGroundColor,
              //     elevation: 0.0,
              //     systemOverlayStyle: SystemUiOverlayStyle.light,
              //   ),
              // ),
              home: AuthWidget(snapShot: snapShot),
              theme: theme
            ));
  }
}
