package com.app.baqalty

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app/control"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "moveToBackground" -> {
                    moveTaskToBack(true) // Move app to background instead of closing
                    result.success(null)
                }
                "exitApp" -> {
                    finishAffinity() // Close the app completely
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
