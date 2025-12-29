import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skeleton/generated/l10n.dart';


enum LanguageType {
  en('en'), fa('fa');

  final String value;
  const LanguageType(this.value);
}
extension OnLanguageType on LanguageType{
  String get humanReadable{
    switch(this) {
      case LanguageType.en:
        return S.current.english;
      case LanguageType.fa:
        return S.current.persian;
    }
  }

}

class LocaleConfigs {
  static Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates {
    return [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }
}
/**/