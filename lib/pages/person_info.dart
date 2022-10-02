import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/task.dart';
import 'package:flutter_application_1/project_theme_options.dart';

class PersonInfo extends StatelessWidget with ProjectThemeOptions{
  PersonInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: ProjectThemeOptions().systemTheme,
        backgroundColor: ProjectThemeOptions().backGroundColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TaskView()),
                  ModalRoute.withName("/Task"));
            }),
      ),
      body: const Text("Kullanıcı"),
    );
  }
}
