import 'package:flutter/material.dart';
import 'package:pomotodo/utils/languages/language_preference.dart';

class LocaleModel extends ChangeNotifier {
  LanguagePreference languagePreference = LanguagePreference();
  Locale _locale = const Locale('tr', 'TR');

  Locale get locale => _locale;

  set locale(Locale value) {
    _locale = value;
    languagePreference.setLanguageCode(value.languageCode);
    languagePreference.setCountryCode(value.countryCode!);
    notifyListeners();
  }
}
