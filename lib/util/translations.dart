import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Translations {
  Translations(this.locale);
  
  final Locale locale;
  
  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }
  
  Map<String, String> _sentences;
  
  Future<bool> load() async {
    String data = await rootBundle.loadString('locale/i18n_${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }
  
  String text(String key) {
    if (!this._sentences.containsKey(key)) return '$key not found';
    return this._sentences[key];  
  }  
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {  
  const TranslationsDelegate();
  
  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);
  
  @override
  Future<Translations> load(Locale locale) async {
    Translations localizations = new Translations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(TranslationsDelegate old) => false;
}