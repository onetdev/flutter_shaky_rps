import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lang {
  final Locale locale;

  Lang(this.locale);

  /// Helper method to keep the code in the widgets concise
  /// Localizations are accessed using an InheritedWidget "of" syntax
  static Lang of(BuildContext context) {
    return Localizations.of<Lang>(context, Lang);
  }

  /// Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<Lang> delegate = _LangDelegate();

  Map<String, String> _localizedStrings;

  /// Load the language JSON file from the "lang" folder
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = _flattenJson(jsonMap);

    return true;
  }

  /// This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? '{LK:$key}';
  }

  /// Creates a 2D array of a JSON file so the getter can access
  /// items using dot notation.
  Map<String, String> _flattenJson(Map<String, dynamic> jsonMap,
      {String prefix = ""}) {
    var result = Map<String, String>();
    jsonMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result.addAll(_flattenJson(value, prefix: "$prefix$key."));
        return;
      }

      result[prefix + key] = value.toString();
    });

    return result;
  }
}

class _LangDelegate extends LocalizationsDelegate<Lang> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _LangDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'hu'].contains(locale.languageCode);
  }

  @override
  Future<Lang> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    Lang localizations = new Lang(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_LangDelegate old) => false;
}
