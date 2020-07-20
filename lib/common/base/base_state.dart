


import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';

abstract class BaseState<T extends StatefulWidget,VM extends BaseViewModel> extends State<T>{


  VM mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = _buildViewModel(context);
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
      child: _buildBody(),
      builder: (context,child)=>child,
    );
  }


  VM _buildViewModel(BuildContext context);

  Widget _buildBody();





}