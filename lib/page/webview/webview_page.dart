import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/widget/common_appbar.dart';
import 'package:wanandroid/widget/progressbar.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  static const String NAME = "Webview";

  final String url;
  final String title;

  WebviewPage({@required this.url, this.title});

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
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: <Widget>[
            ProgressBar(backgroundColor: Colors.grey,progress: 50,progressColor: Theme.of(context).accentColor,size: Size(double.infinity,ScreenUtil().setWidth(2)) ),
            Expanded(
              flex: 1,
              child: WebView(
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                   navigationDelegate: (navigation) async{
                                  if(navigation.url.startsWith("http")||navigation.url.startsWith("https")){
                                    return NavigationDecision.navigate;
                                  }else{
                                    await _launchInBrowser(navigation.url);
                                    return NavigationDecision.prevent;
                                  }
                                },
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  buildViewModel(BuildContext context) {
    return WebviewViewModel();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.close,
      onLeadingIconTap: (){
        Navigator.pop(context);
      },
      widget: Padding(
          padding:
          EdgeInsets.only(right: ScreenUtil().setWidth(16)),
          child: Hero(
            tag: widget.title,
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              style: TextStyles.titleTextStyle,
            ),
          ),
        ),

    );
  }
}

class WebviewViewModel extends BaseViewModel {



  @override
  void initState() {}
}
