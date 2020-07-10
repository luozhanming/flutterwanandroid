package com.example.flutterview

import android.annotation.TargetApi
import android.content.Context
import android.os.Build
import android.view.View
import android.widget.EditText
import android.widget.Switch
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

@TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
class FlutterView(private val context: Context, messenger: BinaryMessenger, params: String?):PlatformView,MethodChannel.MethodCallHandler {

    private val mCaptcha: EditText

    init {
            mCaptcha = EditText(context)

    }

    override fun getView(): View {
        return mCaptcha
    }

    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

    }



}