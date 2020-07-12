


import 'package:flutter/material.dart';
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
    child:  InputChip(
       avatar: CircleAvatar(
         backgroundColor: Colors.grey.shade800,
         child: Text('AB'),
       ),
       label: Text('Aaron Burr'),
       onPressed: () {
         print('I am the one thing in life.');
       }
     )
  );
  }

  Future<int> _getBatteryLevel() async{
    return await Battery.batteryLevel;
  }
}
