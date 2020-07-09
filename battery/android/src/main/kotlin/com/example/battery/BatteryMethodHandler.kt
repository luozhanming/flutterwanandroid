package com.example.battery

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class BatteryMethodHandler(val battery:Battery): MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            "getBatteryLevel"->{
                result.success(battery.getBatteryLevel())
            }
            else->result.notImplemented()
        }
    }
}