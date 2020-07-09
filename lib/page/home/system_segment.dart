


import 'package:flutter/widgets.dart';

import 'package:battery/battery.dart';


class SystemSegment extends StatefulWidget {
  @override
  _SystemSegmentState createState() => _SystemSegmentState();
}

class _SystemSegmentState extends State<SystemSegment> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getBatteryLevel(),
      builder: (context,  snapshot){
        if(snapshot.hasData){
          return  Center(
              child: Text("${snapshot.data}")
          );
        }
        return Center(
          child: Text("体系")
        );
      }
    );
  }

  Future<int> _getBatteryLevel() async{
    return await Battery.batteryLevel;
  }
}
