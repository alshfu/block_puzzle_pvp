import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());
  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  String get appTitle;
  String get classic;
  String get sprint;
  String get ultra;
  String get oneVsOne;
  String get selectMode;
  String get tetris;
  String get classicMode;
  String get snake;
  String get comingSoon;
  String get score;
  String get level;
  String get next;
  String get pause;
  String get resume;
  String get restart;
  String get gameOver;
  String yourScore(int score);
  String get playAgain;
  String get paused;
  String get backToMenu;
  String get puzzleBlockClassic;
  String get highScore;
  String get lastScore;
  String get newHighScore;
  String get settings;
  String get sound;
  String get vibration;
  String get volume;
  String get profile;
  String get playerName;
  String get enterYourName;
  String get save;
  String get playerLevel;
  String get statistics;
  String get overallStats;
  String get gamesPlayed;
  String get totalPlaytime;
  String get tetrisStats;
  String get editProfile;
  String get chooseAvatar;
  String get leaderboard;
  String get topPlayers;
  String get logout;
  String get loginError;
  String get welcome;
  String get signInWithGoogle;
  String get signInWithApple;
  String get continueAsGuest;
  String get loginSuccess;
  String get loginCancelled;
  String get profileSaved; // Добавлено
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }
  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale".');
}
