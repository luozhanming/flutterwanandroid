

import 'package:flutter/cupertino.dart';

abstract class BaseViewModel with ChangeNotifier{

  void initState();

  void dispose(){
    super.dispose();
  }
}