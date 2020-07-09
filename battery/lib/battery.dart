import 'dart:async';

import 'package:flutter/services.dart';

class Battery {
  static const MethodChannel _channel =
      const MethodChannel('battery');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> get batteryLevel async{
    final int level = await _channel.invokeMethod("getBatteryLevel");
    return level;
  }
}
