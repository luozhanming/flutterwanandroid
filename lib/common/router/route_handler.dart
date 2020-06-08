



import 'package:fluro/fluro.dart';
import 'package:wanandroid/app.dart';
import 'package:wanandroid/page/login_page.dart';

var homeHandler = Handler(handlerFunc: (context,params){
  return LoginPage();
});