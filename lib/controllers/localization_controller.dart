// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_info.dart';

class AppLocalizationController extends GetxController {
  // ignore: prefer_const_constructors
  Locale _locale = Locale("en", "US");

  Locale? _tempLocale;

  static final List<LanguageInfo> _supportedLanguages = [
    LanguageInfo(
        countryCode: "US", languageCode: "en", title: "English", flag: "🇺🇸"),
    LanguageInfo(
        countryCode: "SA", languageCode: "ar", title: "Arabic", flag: "🇸🇦"),
  ];

  // ignore: constant_identifier_names
  static const List<String> _rtl_language_codes = [
    'ar', // Arabic
    'fa', // Farsi
    'he', // Hebrew
    'ps', // Pashto
    'ur', // Urdu
  ];

  Locale get currentLocale => _locale;

  Locale? get tempLocale => _tempLocale;

  List<Locale> get locales => _locales;

  static List<LanguageInfo> get supportedLanguages => _supportedLanguages;

  static final List<Locale> _locales = supportedLanguages
      .map<Locale>(
          (language) => Locale(language.languageCode, language.countryCode))
      .toList();

  AppLocalizationController(Locale locale) {
    setLocale(locale);
  }

  AppLocalizationController.empty();

  //in this function we are checking i the current language start from te right side or not
  bool get isRTLanguage {
    return _rtl_language_codes.contains(_locale.languageCode);
  }

  static AppLocalizationController? of(BuildContext context) {
    return Localizations.of<AppLocalizationController>(
        context, AppLocalizationController);
  }

  static Map<String, String> _localizedValues = {};

  //in this function we are loading the locale data from the json file
  Future<void> load(Locale locale) async {
    //getting the json data from the assets
    String jsonStringValues = await rootBundle
        .loadString("assets/languages/${locale.languageCode}.json");

    //decoding the json data
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    //extracting the data from decoded data into a global variable
    _localizedValues = mappedJson
        .map((key, value) => MapEntry<String, String>(key, value.toString()));
    //notifying all the project that something had changed
    update();
  }

  //in this function we are getting the translated value from the json data
  String getTranslatedValue(String key) {
    return _localizedValues[key.trim()] ?? key;
  }

  static final LocalizationsDelegate<AppLocalizationController> delegate =
      _AppLocalizationDelegate(_locales);

  //in this function we are getting the saved locale
  Future<void> getAppLocale() async {
    try {
      //creating an instance from the shared preferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      //checking if there is a saved locale or not
      if (pref.containsKey("locale")) {
        //getting the locale data from the shared preferences
        List<String> localeCodes = pref.getStringList("locale") ?? [];
        //checking if the data is empty or not
        if (localeCodes.isNotEmpty) {
          //setting the app locale
          await setLocale(Locale(
              localeCodes[0], localeCodes[1] == "" ? localeCodes[1] : null));
        }
      }
    } catch (e) {
      print(
          "LOCALIZATION_PROVIDER AppLocalizationProvider getAppLocale error: $e");
    }
  }

  //in this function we are changing the app locale to the new locale
  Future<void> setLocale(Locale locale) async {
    //creating a new instance from the shared preferences to reset/add the locale
    SharedPreferences pref = await SharedPreferences.getInstance();
    //sending the locale data to the shared preferences
    pref.setStringList(
      "locale",
      [
        locale.languageCode,
        locale.countryCode ?? "",
      ],
    );
    //changing the current locale
    _locale = locale;
    //loading the translated data from the json file
    await load(locale);
    update();
  }
}

class _AppLocalizationDelegate
    extends LocalizationsDelegate<AppLocalizationController> {
  final List<Locale> _locales;
  const _AppLocalizationDelegate(this._locales);
  @override
  bool isSupported(Locale locale) {
    List<String> languageCodes =
        _locales.map<String>((tempLocale) => tempLocale.languageCode).toList();

    return languageCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizationController> load(Locale locale) async {
    AppLocalizationController localization = AppLocalizationController(locale);
    await localization.load(locale);
    return localization;
  }

  @override
  bool shouldReload(
      covariant LocalizationsDelegate<AppLocalizationController> old) {
    return false;
  }
}
