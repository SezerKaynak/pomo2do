import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class SelectIcon extends ChangeNotifier {
  List<IconData> icons = const [
    Icons.edit_note,
    Icons.self_improvement,
    Icons.code,
    Icons.work,
    Icons.favorite,
    Icons.grade,
    Icons.menu_book,
  ];
  int codePoint = 984386;
  final List<bool> selectedIcon = [
    true,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  selectIcon(int index) {
    for (int i = 0; i < selectedIcon.length; i++) {
      selectedIcon[i] = i == index;
      codePoint = icons[index].codePoint;
    }
    notifyListeners();
  }
}

class SelectTheme {
  List<IconData> icons = const [Icons.light_mode, Icons.dark_mode];

  List<bool> selectedTheme = [true, false];
}

class SelectLanguage {
  List<CountryFlags> flags = [
    CountryFlags.flag(
      'tr',
      height: 40,
      width: 40,
      borderRadius: 8,
    ),
    CountryFlags.flag(
      'us',
      height: 40,
      width: 40,
      borderRadius: 8,
    ),
  ];

  List<bool> selectedLanguage = [true, false];
}
