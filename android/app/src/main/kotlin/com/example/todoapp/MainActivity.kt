package com.example.todoapp
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    

        // custom method to get flavor
        MethodChannel(getFlutterEngine()!!.getDartExecutor()!!.getBinaryMessenger(), "flavor").setMethodCallHandler{call,result ->
                result.success(BuildConfig.FLAVOR)
        }
    }
}
