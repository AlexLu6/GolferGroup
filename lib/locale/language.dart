import 'package:flutter/material.dart';

abstract class Language {
  static Language of(BuildContext context) {
    return Localizations.of<Language>(context, Language)!;
  }
  String get appTitle;
  String get golferInfo;
  String get groups;
  String get activities;
  String get golfCourses;
  String get myScores;
  String get groupActivity;
  String get logOut;

  String get name;
  String get mobile;
  String get male;
  String get female;
  String get register;
  String get modify;
  String get handicap;

  String get region;
  String get manager;
  String get members;
  String get teeOff;
  String get fee;
  String get tableGroup;
  String get apply;
  String get cancel;
  String get waiting;
  String get create;
  String get max;
  String get now;
}