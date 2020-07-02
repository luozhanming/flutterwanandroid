import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/page/home_page.dart';
import 'package:wanandroid/page/login_page.dart';
import 'package:wanandroid/redux/app_redux.dart';

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> {
  final Store store = Store<AppState>(appReducer);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale("zh", "CN"),
            ...S.delegate.supportedLocales
          ],
          theme: ThemeData(

          ),
          routes: {
            "/":(context){
              return HomePage();
            }
          },
        ));
  }
}
