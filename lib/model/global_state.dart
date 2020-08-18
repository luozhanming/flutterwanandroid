import 'package:flutter/material.dart';
import 'package:wanandroid/model/user.dart';

class GlobalState with ChangeNotifier {
  User loginUser = null;

  bool isLogin = false;

  Locale locale = Locale("zh", "CN");


  GlobalState({this.loginUser, this.isLogin, this.locale});

  ThemeData themeData = ThemeData(
  );

  void setLoginUser(User user) {
    if (user != loginUser) {
      loginUser = user;
      isLogin = true;
    }
    notifyListeners();
  }


  void logout(){
    loginUser = null;
    isLogin = false;
    notifyListeners();
  }

  void setLocal(Locale locale){
    this.locale = locale;
    notifyListeners();
  }


  void setTheme(ThemeData data){
    if(data!= themeData){
      themeData = data;
    }
    notifyListeners();
  }
}
