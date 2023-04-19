import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreference {
  static const LOCALE_LANGUAGECODE = "LOCALELANGUAGECODE";
  static const LOCALE_COUNTRYCODE = "LOCALECOUNTRYCODE";

  setLanguageCode(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LOCALE_LANGUAGECODE, value);
  }

  setCountryCode(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LOCALE_COUNTRYCODE, value);
  }

  Future<List<String>> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> languageAndCountryCode = [];

    String languageCode = prefs.getString(LOCALE_LANGUAGECODE) ??
        const Locale("tr", "TR").languageCode;
    String countryCode = prefs.getString(LOCALE_COUNTRYCODE) ??
        const Locale("tr", "TR").countryCode!;
    languageAndCountryCode.addAll([languageCode, countryCode]);
    return languageAndCountryCode;
  }
}
