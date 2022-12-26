import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/utils/themes/dark_theme_preference.dart';
import 'package:provider/provider.dart';

class DarkThemeProvider with ChangeNotifier{
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}