package com.example.webview_cookie_jar

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WebviewCookieJarPlugin */
class WebviewCookieJarPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "webview_cookie_jar")
    channel.setMethodCallHandler { call, result ->
      when (call.method) {
        "loadForRequest" -> {
          val urlInArgs = call.arguments as? String
          if (urlInArgs != null) {
            val cookies = CookieManager.getInstance().getCookie(urlInArgs)
            val results = cookies?.split(";") ?: emptyList()
            result.success(results)
          } else {
            result.success(emptyList<String>())
          }
        }
        "saveFromResponse" -> {
          val mapArgs = call.arguments as? Map<*, *>
          val urlInArgs = mapArgs?.get("url") as? String
          val setCookies = mapArgs?.get("Set-Cookie") as? List<String>
          if (urlInArgs != null && setCookies != null) {
            for (item in setCookies){
              CookieManager.getInstance().setCookie(urlInArgs, item)
            }
          }
          result.success(true)
        }
        "deleteAll" -> {
          CookieManager.getInstance().apply {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
              removeAllCookies(null)
              result.success(true)
            } else {
              result.success(false)
            }
          }
        }
        "delete" -> {
          val mapArgs = call.arguments as? Map<*, *>
          val url = mapArgs?.get("url") as? String
          val name = mapArgs?.get("name") as? String
          val domain = mapArgs?.get("domain") as? String
          val path = mapArgs?.get("path") as? String
          CookieManager.getInstance().setCookie(url ?: domain, "${name ?: ""}=; Domain=${domain ?: url}; Path=${path ?: "/"}; Max-Age=0")
          result.success(true)
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
