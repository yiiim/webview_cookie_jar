import 'webview_cookie_jar_platform_interface.dart';

class WebViewCookieJar {
  /// warning！！！
  /// delete(Uri uri, [bool withDomainSharedCookie = false]) is not implemented, calling this method will do nothing
  /// Please use the deleteCookie method
  static WebViewCookieJarPlatform get cookieJar => WebViewCookieJarPlatform.instance;
}
