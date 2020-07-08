// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `请输入用户名`
  String get hint_input_username {
    return Intl.message(
      '请输入用户名',
      name: 'hint_input_username',
      desc: '',
      args: [],
    );
  }

  /// `请输入密码`
  String get hint_input_password {
    return Intl.message(
      '请输入密码',
      name: 'hint_input_password',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get search_website_content {
    return Intl.message(
      'search',
      name: 'search_website_content',
      desc: '',
      args: [],
    );
  }

  /// `首页`
  String get home {
    return Intl.message(
      '首页',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `体系`
  String get tixi {
    return Intl.message(
      '体系',
      name: 'tixi',
      desc: '',
      args: [],
    );
  }

  /// `公众号`
  String get gongzonghao {
    return Intl.message(
      '公众号',
      name: 'gongzonghao',
      desc: '',
      args: [],
    );
  }

  /// `导航`
  String get navigation {
    return Intl.message(
      '导航',
      name: 'navigation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}