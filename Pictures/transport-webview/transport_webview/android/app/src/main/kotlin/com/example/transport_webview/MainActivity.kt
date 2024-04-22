package com.example.transport_webview

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import java.util.Locale
import android.content.res.Configuration

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val locale = Locale("es", "ES")
        Locale.setDefault(locale)
        val config = Configuration()
        config.setLocale(locale)
        baseContext.resources.updateConfiguration(config, baseContext.resources.displayMetrics)
    }
}
