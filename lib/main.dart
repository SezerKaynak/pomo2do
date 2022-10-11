import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/pages/edit_profile.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/firebase_service.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/auth_widget.dart';
import 'package:flutter_application_1/widgets/auth_widget_builder.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<IAuthService>(create: (_) => AuthService())],
      child: AuthWidgetBuilder(
          onPageBuilder: (context, AsyncSnapshot<PomotodoUser?> snapShot) =>
              MaterialApp(
                initialRoute: '/',
                routes: {
                  '/task': (context) => TaskView(),
                  '/person': (context) => PersonInfo(),
                  '/editProfile': (context) => const EditProfile(),
                },
                debugShowCheckedModeBanner: false,
                theme: ThemeData().copyWith(
                  appBarTheme: AppBarTheme(
                    backgroundColor: ProjectThemeOptions().backGroundColor,
                    elevation: 0.0,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                  ),
                ),
                home: AuthWidget(snapShot: snapShot),
              )),
    );
  }
}
