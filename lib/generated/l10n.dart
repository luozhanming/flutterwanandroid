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

  /// `Please input your username.`
  String get hint_input_username {
    return Intl.message(
      'Please input your username.',
      name: 'hint_input_username',
      desc: '',
      args: [],
    );
  }

  /// `Please input your password.`
  String get hint_input_password {
    return Intl.message(
      'Please input your password.',
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

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get tixi {
    return Intl.message(
      'System',
      name: 'tixi',
      desc: '',
      args: [],
    );
  }

  /// `Pub`
  String get gongzonghao {
    return Intl.message(
      'Pub',
      name: 'gongzonghao',
      desc: '',
      args: [],
    );
  }

  /// `Navigation`
  String get navigation {
    return Intl.message(
      'Navigation',
      name: 'navigation',
      desc: '',
      args: [],
    );
  }

  /// `Author:`
  String get author {
    return Intl.message(
      'Author:',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `ShareUser:`
  String get shareUser {
    return Intl.message(
      'ShareUser:',
      name: 'shareUser',
      desc: '',
      args: [],
    );
  }

  /// `Time:`
  String get time {
    return Intl.message(
      'Time:',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Can not open this link.`
  String get tip_can_not_open_link {
    return Intl.message(
      'Can not open this link.',
      name: 'tip_can_not_open_link',
      desc: '',
      args: [],
    );
  }

  /// `Hots`
  String get search_hots {
    return Intl.message(
      'Hots',
      name: 'search_hots',
      desc: '',
      args: [],
    );
  }

  /// `Records`
  String get search_record {
    return Intl.message(
      'Records',
      name: 'search_record',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register_new_user {
    return Intl.message(
      'Register',
      name: 'register_new_user',
      desc: '',
      args: [],
    );
  }

  /// `AutoLogin`
  String get auto_login {
    return Intl.message(
      'AutoLogin',
      name: 'auto_login',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project {
    return Intl.message(
      'Project',
      name: 'project',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Empty data!`
  String get no_data {
    return Intl.message(
      'Empty data!',
      name: 'no_data',
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