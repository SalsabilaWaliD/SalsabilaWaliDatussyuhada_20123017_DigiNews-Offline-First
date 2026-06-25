package com.salsabila.diginews

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    // ============================================================
    // 🔥 TANTANGAN ANTI-AI: MethodChannel
    // Kirim NIM dari Dart ke Kotlin → Kotlin balik → kirim balik → Toast
    // ============================================================
    private val CHANNEL = "com.salsabila.diginews/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "reverseNim" -> {
                        // 1. Ambil NIM dari Dart
                        val nim: String = call.argument("nim") ?: ""

                        // 2. Balik string NIM di dalam Kotlin
                        // "20123017" → "71032102"
                        val reversedNim: String = nim.reversed()

                        // 3. Tampilkan Native Toast Android
                        Toast.makeText(
                            this,
                            "NIM terbalik: $reversedNim",
                            Toast.LENGTH_LONG
                        ).show()

                        // 4. Kembalikan hasil ke Dart
                        result.success(reversedNim)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
