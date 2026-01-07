package top.amirdeveloper.skeleton

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var kiosk: KioskManager
    private val CHANNEL = "kiosk_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        kiosk = KioskManager(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startKiosk" -> {
                        kiosk.start()
                        result.success(true)
                    }
                    "stopKiosk" -> {
                        kiosk.stop()
                        result.success(true)
                    }
                    "isInKiosk" -> {
                        result.success(kiosk.isInKiosk())
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
