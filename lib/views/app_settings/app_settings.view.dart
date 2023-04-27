import 'package:flutter/material.dart';
import 'package:pomotodo/views/app_settings/app_settings.widgets.dart';

class AppSettingsView extends StatelessWidget
    with AppSettingsWidgets {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: body(context),
    );
  }
}
