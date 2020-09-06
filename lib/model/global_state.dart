import 'package:flutter/material.dart';
import 'package:wanandroid/model/user.dart';

class GlobalState with ChangeNotifier {

  GlobalState();

  ThemeData themeData = ThemeData(
    primaryColor: Colors.yellow,
  );

  User loginUser = null;

  bool isLogin = false;

  Locale locale = Locale("zh", "CN");

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
