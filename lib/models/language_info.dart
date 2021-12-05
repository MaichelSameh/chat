class LanguageInfo {
  late final String _countryCode;
  late final String _flag;
  late final String _languageCode;
  late final String _title;
  LanguageInfo({
    required String countryCode,
    required String flag,
    required String languageCode,
    required String title,
  }) {
    _countryCode = countryCode;
    _flag = flag;
    _languageCode = languageCode;
    _title = title;
  }

  String get countryCode => _countryCode;
  String get flag => _flag;
  String get languageCode => _languageCode;
  String get title => _title;

  @override
  String toString() {
    return '''
      country_code: $countryCode,
      flag: $flag,
      language_code: $languageCode,
      title: $title
    ''';
  }
}
