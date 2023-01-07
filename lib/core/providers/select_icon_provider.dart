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
  int codePoint = 984310;
  final List<bool> selectedWeather = [
    true,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  selectedIcon(int index) {
    for (int i = 0; i < selectedWeather.length; i++) {
      selectedWeather[i] = i == index;
      codePoint = icons[index].codePoint;
    }
    notifyListeners();
  }
}
