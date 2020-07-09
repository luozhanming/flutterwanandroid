package com.example.battery

import android.content.Context

class Battery(private val mContext:Context) {
    fun getBatteryLevel():Int {
        return 25;
    }
}