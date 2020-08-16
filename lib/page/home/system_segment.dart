import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/system_knowlodge.dart';
import 'package:wanandroid/repository/system_repository.dart';

class SystemSegment extends StatefulWidget {
  SystemSegment({Key key}) : super(key: key);

  @override
  _SystemSegmentState createState() => _SystemSegmentState();
}

class _SystemSegmentState extends BaseState<SystemSegment, SystemViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  buildViewModel(BuildContext context) => SystemViewModel();
}

class SystemViewModel extends BaseViewModel {
  SystemRepository _repository;
  CompositeSubscription _subscriptions;

  /*数据层*/
  ChapterSelection selection = ChapterSelection(false);

  Resource<List<SystemKnowlodge>> chapterRes;

  @override
  void initState() {
    _repository = SystemRepository();
    _subscriptions = CompositeSubscription();
    loadSystemTree();
  }

  void loadSystemTree() {
    _repository.loadSystemTree().listen((event) {
      chapterRes = event;
      var data = event.data;
      //默认选第一个
      selection = ChapterSelection(true, parentChapter: data[0]);
    }, onError: (error) {
      if(error is Resource){
        chapterRes = error;
      }else{
        chapterRes = Resource.error();
      }
    });
  }
}

class ChapterSelection {
  final bool hasSeleted;
  final SystemKnowlodge parentChapter;
  final SystemKnowlodge chapter;

  ChapterSelection(this.hasSeleted, {this.parentChapter, this.chapter});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChapterSelection &&
              runtimeType == other.runtimeType &&
              hasSeleted == other.hasSeleted &&
              parentChapter == other.parentChapter &&
              chapter == other.chapter;

  @override
  int get hashCode =>
      hasSeleted.hashCode ^
      parentChapter.hashCode ^
      chapter.hashCode;




}
