package com.example.flutterview

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ViewFactory(val messenger: BinaryMessenger):PlatformViewFactory(StandardMessageCodec.INSTANCE) {


    override fun create(context: Context, viewId: Int, args: Any): PlatformView {
        val params = args as? Map<String,Any>
        return FlutterView(context,messenger,"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1644792247,4040788430&fm=26&gp=0.jpg")
    }
}