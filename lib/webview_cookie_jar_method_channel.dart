import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview_cookie_jar_platform_interface.dart';

/// An implementation of [WebViewCookieJarPlatform] that uses method channels.
class MethodChannelWebViewCookieJar extends WebViewCookieJarPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('webview_cookie_jar');

  @override
  Future<void> delete(Uri uri, [bool withDomainSharedCookie = false]) async {}

  @override
  Future<void> deleteAll() async {
    await methodChannel.invokeMethod("deleteAll");
  }

  @override
  bool get ignoreExpires => true;

  @override
  Future<List<Cookie>> loadForRequest(Uri uri) async {
    var result = await methodChannel.invokeMethod("loadForRequest", uri.toString());
    if (result is List) {
      List<Cookie> cookies = [];
      for (var element in result) {
        if (element is String) {
          try {
            cookies.add(Cookie.fromSetCookieValue(element));
          } catch (_) {}
        }
      }
      return cookies;
    }
    return [];
  }

  @override
  Future<void> saveFromResponse(Uri uri, List<Cookie> cookies) async {
    await methodChannel.invokeMethod(
      "saveFromResponse",
      {
        "url": uri.toString(),
        "Set-Cookie": cookies.map((e) => e.toString()).toList(),
      },
    );
  }

  @override
  Future deleteCookie(Uri uri, Cookie cookie) async {
    await methodChannel.invokeMethod(
      "delete",
      {
        "url": uri.toString(),
        "name": cookie.name,
        "domain": cookie.domain,
        "path": cookie.path,
      },
    );
  }
}
