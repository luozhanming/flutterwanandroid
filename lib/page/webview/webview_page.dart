import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {

  static const String NAME = "Webview";

  final String url;
  final String title;

  WebviewPage({@required this.url,this.title});

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends BaseState<WebviewPage, WebviewViewModel> {

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _webViewController = null;
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(await _webViewController.canGoBack()){
          _webViewController.goBack();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          child: WebView(
            onWebViewCreated: (controller){
              _webViewController = controller;
            },
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true
          ),
        ),
      ),
    );
  }

  @override
  buildViewModel(BuildContext context) {
    return WebviewViewModel();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
            ScreenUtil().setWidth(40)),
        child: AppBar(
          leading: Center(),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
                  Builder(
                    //将context范围缩到Scaffold
                    builder: (context) => Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(40),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        constraints: BoxConstraints(
                            maxWidth: ScreenUtil().setWidth(40),
                            maxHeight: ScreenUtil().setWidth(40)),
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
                  Text(
                    widget.title,
                    softWrap:true,
                    maxLines: 1,
                    style: TextStyles.titleTextStyle,
                  )
                ],
              ),
            ),
          ), //// AppBar是固定56高度的
        ));
  }
}

class WebviewViewModel extends BaseViewModel {
  @override
  void initState() {}
}
