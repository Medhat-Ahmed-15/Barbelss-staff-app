// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:gym_staff_app/l10n/l10n.dart';

class LocaleLanguageProvider extends ChangeNotifier {
  Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
