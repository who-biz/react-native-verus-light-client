package com.verusmobile.veruslightclient;

import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

import android.util.Log;

class VerusLightClient(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    private var synchronizerMap = mutableMapOf<String, SdkSynchronizer>()

    private val networks = mapOf("mainnet" to ZcashNetwork.Mainnet, "testnet" to ZcashNetwork.Testnet)

    override fun getName() = "VerusLightClient"

    @ReactMethod
    fun testReactMethod(msg: String) {
        Log.d("com.veruslightclient", "msg: $msg")
    }

}
