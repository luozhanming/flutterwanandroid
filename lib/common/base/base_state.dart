import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';

import '../../app.dart';

abstract class BaseState<T extends StatefulWidget, VM extends BaseViewModel>
    extends State<T> with RouteAware, LifecycleAware, LifecycleMixin {
  VM mViewModel;

  @override
  void initState() {
    log("initState()", name: runtimeType.toString());
    super.initState();
    mViewModel = buildViewModel(context);
    mViewModel.initState();
  }

  @override
  void dispose() {
    log("dispose()", name: runtimeType.toString());
    routeObserver.unsubscribe(this);
    mViewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    log("didChangeDependencies()", name: runtimeType.toString());
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    log("didUpdateWidget()", name: runtimeType.toString());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    log("reassemble()", name: runtimeType.toString());
  }

  @override
  void activate() {
    log("activate()", name: runtimeType.toString());
    super.activate();
  }

  @override
  void deactivate() {
    log("deactivate()", name: runtimeType.toString());
    super.deactivate();
  }

  @override
  void pause() {
    log("pause()", name: runtimeType.toString());
  }

  @override
  void rusumed() {
    log("rusumed()", name: runtimeType.toString());
  }

  @override
  Widget build(BuildContext context) {
    log("build()", name: runtimeType.toString());

    return ChangeNotifierProvider(
      create: (context) => mViewModel,
      builder: (context, child) => buildBody(context),
    );
  }

  VM buildViewModel(BuildContext context);

  Widget buildBody(BuildContext context);

  void onCreate() {
    log("onCreate()", name: runtimeType.toString());
  }

  void onStart() {
    log("onStart()", name: runtimeType.toString());
  }

  void onResume() {
    log("onResume()", name: runtimeType.toString());
  }

  void onPause() {
    log("onPause()", name: runtimeType.toString());
  }

  void onStop() {
    log("onStop()", name: runtimeType.toString());
  }

  void onDestroy() {
    log("onDestroy()", name: runtimeType.toString());
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.push) {
      onCreate();
    } else if (event == LifecycleEvent.visible) {
      onStart();
    } else if (event == LifecycleEvent.active) {
      onResume();
    } else if (event == LifecycleEvent.inactive) {
      onPause();
    } else if (event == LifecycleEvent.invisible) {
      onStop();
    } else if (event == LifecycleEvent.pop) {
      onDestroy();
    }
  }
}

class LifeCycle extends ChangeNotifier {
  static const int IDEL = 0;
  static const int CREATE = 1000;
  static const int START = 1001;
  static const int STOP = 1002;
  static const int DESTROY = 1003;

  int curLifeCycle = IDEL;

  void changeLifeCycle(int lifecycle) {
    curLifeCycle = lifecycle;
    notifyListeners();
  }
}
