


import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';

abstract class BaseState<T extends StatefulWidget,VM extends BaseViewModel> extends State<T>{


  VM mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = buildViewModel(context);
    mViewModel.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mViewModel.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VM>(
      create:(context)=> mViewModel,
      builder: (context,child)=>buildBody(context),
    );
  }


  VM buildViewModel(BuildContext context);

  Widget buildBody(BuildContext context);





}