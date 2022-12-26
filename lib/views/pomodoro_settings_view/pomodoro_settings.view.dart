import 'package:flutter/material.dart';
import 'package:pomotodo/views/pomodoro_settings_view/pomodoro_settings.widgets.dart';

class PomodoroSettingsView extends StatelessWidget
    with PomodoroSettingsWidgets {
  const PomodoroSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: body(context),
    );
  }
}
