

import 'package:flutter/cupertino.dart';

abstract class BaseViewModel with ChangeNotifier{

  static const int STATE_IDEL = 1001;
  static const int STATE_LOADING = 1002;
  static const int STATE_SUCCESS = 1003;
  static const int STATE_FAILED = 1004;
  static const int STATE_LOADMORE = 1005;

  int state = STATE_IDEL;

  void initState();

  void dispose(){
   // super.dispose();
  }
}