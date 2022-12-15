import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_application_1/widgets/error_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key, required this.snapShot});
  final AsyncSnapshot<PomotodoUser?> snapShot;
  @override
  Widget build(BuildContext context) {
    final pomodoroSettings = Provider.of<SharedPreferences>(context);
    if (snapShot.connectionState == ConnectionState.active) {
      void setPomodoroSettings() {
        pomodoroSettings.setInt('workTimerSelect', 25);
        pomodoroSettings.setInt('breakTimerSelect', 5);
        pomodoroSettings.setInt('longBreakTimerSelect', 30);
        pomodoroSettings.setInt('longBreakNumberSelect', 4);
      }
      if (pomodoroSettings.getInt('workTimerSelect') == null) {
        setPomodoroSettings();
      }

      return snapShot.hasData ? TaskView() : const LoginPage();
    }
    return const ErrorPage();
  }
}
