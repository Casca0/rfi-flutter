package com.mms.rfi

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "oauth2_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        try {
                            val serviceIntent = Intent(this, OAuth2Service::class.java)
                            startForegroundService(serviceIntent)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "SERVICE_ERROR",
                                "Erro ao iniciar service: ${e.message}",
                                null,
                            )
                        }
                    }

                    "stopService" -> {
                        try {
                            val serviceIntent = Intent(this, OAuth2Service::class.java)
                            stopService(serviceIntent)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "SERVICE_ERROR",
                                "Erro ao parar service: ${e.message}",
                                null,
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
