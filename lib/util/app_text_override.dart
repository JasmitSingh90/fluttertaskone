import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTextOverride extends DefaultMaterialLocalizations{
   AppTextOverride(Locale locale) : super();
   @override
   String get backButtonTooltip => null;
}

class AppTextDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const AppTextDelegate();
  
  @override
  Future<AppTextOverride> load(Locale locale) {
    return SynchronousFuture(AppTextOverride(locale));
  }

  @override
  bool shouldReload(AppTextDelegate old) => false;

  @override
  bool isSupported(Locale locale) => true;
}