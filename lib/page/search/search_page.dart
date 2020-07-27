import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/db/home_repository.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/search_hot.dart';
import 'package:wanandroid/widget/common_appbar.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatefulWidget {
  static const String NAME = "Search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage, SearchViewModel> {
  PreferredSize _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.arrow_back,
      onLeadingIconTap: () => Navigator.pop(context),
      widget: _buildSearchField(context),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
      decoration: ShapeDecoration(
          color: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil().setWidth(15))))),
      height: ScreenUtil().setWidth(24),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(240),
            child: TextField(
              textInputAction: TextInputAction.search,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(14), color: Colors.white),
              decoration: InputDecoration(
                hintText: S
                    .of(context)
                    .search_website_content,
                hintStyle: TextStyle(color: Colors.white70),
                contentPadding:
                EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderSide: BorderSide.none,
                  borderRadius:
                  BorderRadius.circular(ScreenUtil().setWidth(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
            color: Colors.white70,
            width: ScreenUtil().setWidth(1),
            height: ScreenUtil().setWidth(18),
          ),
          Container(
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setWidth(20),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                Fluttertoast.showToast(msg: "sdfsdf");
              },
              child: Icon(Icons.search,
                  size: ScreenUtil().setWidth(18), color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
            children: <Widget>[
            _buildSearchHots(context)
        ],
      ),
    ),);
  }

  @override
  buildViewModel(BuildContext context) {
    return SearchViewModel();
  }

  Widget _buildSearchHots(BuildContext context) {
    return Builder(
      builder: (context) {
        var hots = context.select<SearchViewModel, List<SearchHot>>((
            value) => value.hots);
        List<Widget> hotWidget = [];
        hots.forEach((element) {
          hotWidget.add(Container(
            child: InputChip(label: Text(
              element.name,style: TextStyle(fontSize: ScreenUtil().setWidth(14),color: Colors.black54),
            ),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
              side: BorderSide(width: 0,color: Colors.grey,style: BorderStyle.none)
            ),
            onPressed: (){},
            ),
          ));
          });
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
          child: Wrap(
            spacing: ScreenUtil().setWidth(20),
            children: <Widget>[
              ...hotWidget
            ],
          ),
        );
      }
    );
  }
}

class SearchViewModel extends BaseViewModel {
  List<SearchHot> hots = [];
  HomeModel _model;
  CompositeSubscription _subscriptions;

  @override
  void initState() {
    _model = HomeModel();
    _subscriptions = CompositeSubscription();
    loadSearchHots();
  }

  void loadSearchHots() {
    _subscriptions.add(_model.loadSearchHot().listen((event) {
      hots = event;
      notifyListeners();
    }));
  }


  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
  }
}
