class CountryInfo {
  CountryInfo({
    required String name,
    required String phoneCode,
    required String emoji,
    required String code,
    required String iso3,
    required String capital,
    required String currency,
    required String language,
  }) {
    _name = name;
    _phoneCode = phoneCode;
    _emoji = emoji;
    _code = code;
    _iso3 = iso3;
    _capital = capital;
    _currency = currency;
    _language = language;
  }

  CountryInfo.fromJSON(Map<String, dynamic> json) {
    _name = json["name"];
    _phoneCode = "+" + json["phone_code"].toString().replaceFirst("+", "");
    _emoji = json["emoji"];
    _code = json["code"];
    _iso3 = json["iso3"];
    _capital = json["capital"];
    _currency = json["currency"];
    _language = json["language"];
  }

  late String _capital;
  late String _code;
  late String _currency;
  late String _emoji;
  late String _iso3;
  late String _language;
  late String _name;
  late String _phoneCode;

  @override
  String toString() {
    return 'CountryInfo(name: $name, phoneCode: $phoneCode, flag: $flag, code: $code, iso3: $iso3, capital: $capital, currency: $currency, language: $language)';
  }

  String get name => _name;

  String get phoneCode => _phoneCode;

  String get flag => _emoji;

  String get code => _code;

  String get iso3 => _iso3;

  String get capital => _capital;

  String get currency => _currency;

  String get language => _language;
}
