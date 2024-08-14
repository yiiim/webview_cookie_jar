# webview_cookie_jar

Implement [cookie_jar](https://pub.dev/packages/cookie_jar). using the native webview to manage cookies. Any cookie operations will affect the webview, and any cookie operations within the webview will affect this cookie. This will make the cookies in the app and the webview completely consistent

Supported platforms: iOS, Android.

## Usage

`WebViewCookieJar.cookieJar` obtains a `CookieJar`. For usage, refer to [cookie_jar](https://pub.dev/packages/cookie_jar).

### Use with dio

```dart
import 'package:dio/dio.dart';
import 'package:webview_cookie_jar/webview_cookie_jar.dart';

void main() async {
  final dio = Dio();
  dio.interceptors.add(CookieManager(WebViewCookieJar.cookieJar));
}
```

> note :`delete(Uri uri, [bool withDomainSharedCookie = false])` is not implemented, calling this method will do nothing Please use the `deleteCookie` method.
