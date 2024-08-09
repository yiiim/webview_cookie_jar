import 'package:cookie_jar/cookie_jar.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'webview_cookie_jar_method_channel.dart';

abstract class WebViewCookieJarPlatform extends PlatformInterface implements CookieJar {
  WebViewCookieJarPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebViewCookieJarPlatform _instance = MethodChannelWebViewCookieJar();

  static WebViewCookieJarPlatform get instance => _instance;

  static set instance(WebViewCookieJarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future deleteCookie(Uri uri, Cookie cookie);
}
