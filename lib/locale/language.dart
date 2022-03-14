import 'package:flutter/material.dart';

abstract class Language {
  static Language of(BuildContext context) {
    return Localizations.of<Language>(context, Language)!;
  }
  String get appTitle;
  String get golferInfo;
}