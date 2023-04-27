import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/locale_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:provider/provider.dart';

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

  List<Widget> flags = [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          CountryFlags.flag(
            'tr',
            height: 35,
            width: 35,
            borderRadius: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Consumer<LocaleModel>(
              builder: (context, value, child) {
                return Text(L10n.of(context)!.turkish);
              },
            ),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          CountryFlags.flag(
            'us',
            height: 35,
            width: 35,
            borderRadius: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Consumer<LocaleModel>(
              builder: (context, value, child) {
                return Text(L10n.of(context)!.english);
              },
            ),
          )
        ],
      ),
    ),
  ];

  List<bool> selectedLanguage = [true, false];
}
