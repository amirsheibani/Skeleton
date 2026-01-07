package top.amirdeveloper.skeleton

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "top.amirdeveloper.skeleton/kiosk"
    private lateinit var kioskManager: KioskManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        kioskManager = KioskManager(this)
        
        // Automatically enable kiosk mode if device owner
        if (kioskManager.isDeviceOwner() && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            kioskManager.enableLockTaskMode()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                kioskManager.setKioskRestrictions()
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isDeviceOwner" -> {
                    result.success(kioskManager.isDeviceOwner())
                }
                "isDeviceAdminActive" -> {
                    result.success(kioskManager.isDeviceAdminActive())
                }
                "requestDeviceAdmin" -> {
                    kioskManager.requestDeviceAdmin()
                    result.success(null)
                }
                "enableLockTaskMode" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        kioskManager.enableLockTaskMode()
                        result.success(true)
                    } else {
                        result.error("UNSUPPORTED", "Lock Task Mode requires Android 5.0+", null)
                    }
                }
                "disableLockTaskMode" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        kioskManager.disableLockTaskMode()
                        result.success(true)
                    } else {
                        result.error("UNSUPPORTED", "Lock Task Mode requires Android 5.0+", null)
                    }
                }
                "isLockTaskModeActive" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        result.success(kioskManager.isLockTaskModeActive())
                    } else {
                        result.success(false)
                    }
                }
                "setKioskRestrictions" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        kioskManager.setKioskRestrictions()
                        result.success(true)
                    } else {
                        result.error("UNSUPPORTED", "Kiosk restrictions require Android 6.0+", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        // Re-enable lock task mode if device owner (in case it was disabled)
        if (kioskManager.isDeviceOwner() && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if (!kioskManager.isLockTaskModeActive()) {
                kioskManager.enableLockTaskMode()
            }
        }
    }

    override fun onBackPressed() {
        // Prevent back button in kiosk mode
        if (kioskManager.isDeviceOwner() && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (kioskManager.isLockTaskModeActive()) {
                // Don't call super - prevent back button
                return
            }
        }
        super.onBackPressed()
    }
}
