import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/dark_theme_provider.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/widgets/custom_switch.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deneme extends StatefulWidget {
  const Deneme({super.key});

  @override
  State<Deneme> createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _count;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _count = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('workTimerSelect') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        body: Center(
      child: CustomSwitch(
        switchValue: themeChange.darkTheme,
        switchOnChanged: (bool? value) {
          themeChange.darkTheme = value!;
        },
      ),
    ));
  }
}
