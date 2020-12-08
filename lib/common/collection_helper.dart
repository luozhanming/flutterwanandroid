


import 'package:flutter/widgets.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/repository/collect_repository.dart';
import 'package:provider/provider.dart';


///dart单例写法
class CollectionHelper{


  static final CollectionHelper _helper = CollectionHelper._();

  ICollectionsRepository _repository;



  CollectionHelper._(){
    _repository = new RemoteCollectionsRepository();
  }

  factory CollectionHelper.getHelper()=>_helper;


  void collect(BuildContext context,Artical artical){
    _repository.collectArtical(artical).listen((event) {
      if(event){
        context.read<GlobalState>().addCollect(artical.id);
      }

    },onError: (error){
     
    });
  }

}