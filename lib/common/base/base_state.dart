


import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';

import '../../app.dart';

abstract class BaseState<T extends StatefulWidget,VM extends BaseViewModel> extends State<T> with RouteAware{


  VM mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = buildViewModel(context);
    mViewModel.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
    mViewModel.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>mViewModel,
      builder: (context,child)=>buildBody(context),
    );
  }


  VM buildViewModel(BuildContext context);

  Widget buildBody(BuildContext context);

}


class LifeCycle extends ChangeNotifier{
  static const int IDEL = 0;
  static const int CREATE = 1000;
  static const int START = 1001;
  static const int STOP = 1002;
  static const int DESTROY = 1003;

  int curLifeCycle = IDEL;

  void changeLifeCycle(int lifecycle){
    curLifeCycle = lifecycle;
    notifyListeners();
  }

  
}

