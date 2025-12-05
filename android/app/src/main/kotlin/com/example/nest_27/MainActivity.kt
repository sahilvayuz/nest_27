package com.example.nest_27

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "app.icon"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "changeIcon") {
                val iconName = call.argument<String>("iconName") ?: "icon_default"
                changeIcon(iconName)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun changeIcon(iconName: String) {
        val pm = packageManager

        val defaultComponent = ComponentName(this, "com.example.nest_27.IconDefault")
        val festiveComponent = ComponentName(this, "com.example.nest_27.IconFestive")

        fun enable(component: ComponentName) {
            pm.setComponentEnabledSetting(
                component,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )
        }

        fun disable(component: ComponentName) {
            pm.setComponentEnabledSetting(
                component,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }

        if (iconName == "icon_festive") {
            enable(festiveComponent)
            disable(defaultComponent)
        } else {
            enable(defaultComponent)
            disable(festiveComponent)
        }
    }
}
