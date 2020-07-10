


import 'package:flutter/widgets.dart';

import 'package:battery/battery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SystemSegment extends StatefulWidget {
  @override
  _SystemSegmentState createState() => _SystemSegmentState();
}

class _SystemSegmentState extends State<SystemSegment> {
  @override
  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: _getBatteryLevel(),
//      builder: (context,  snapshot){
//        if(snapshot.hasData){
//          return  Center(
//              child: Text("${snapshot.data}")
//          );
//        }
//        return Center(
//          child: Text("体系")
//        );
//      }
//    );
  return Center(
    child: Container(
      width: ScreenUtil().setWidth(320),
      height: ScreenUtil().setWidth(200),
      child: AndroidView(
        viewType: "flutterview",
        creationParams: "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1644792247,4040788430&fm=26&gp=0.jpg",
      ),
    ),
  );
  }

  Future<int> _getBatteryLevel() async{
    return await Battery.batteryLevel;
  }
}
