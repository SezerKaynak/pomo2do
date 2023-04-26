import 'package:flutter/material.dart';
import 'package:pomotodo/views/notification_settings/notification_settings.widgets.dart';

class NotificationSettingsView extends StatelessWidget
    with NotificationSettingsWidgets {
  const NotificationSettingsView({super.key});

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
