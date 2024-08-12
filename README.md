# webview_cookie_jar

Implement [cookie_jar](https://pub.dev/packages/cookie_jar). using the native webview to manage cookies. Any cookie operations will affect the webview, and any cookie operations within the webview will affect this cookie.

Supported platforms: iOS, Android.

## Usage

`WebViewCookieJar.cookieJar` obtains a `CookieJar`. For usage, refer to [cookie_jar](https://pub.dev/packages/cookie_jar).

> `delete(Uri uri, [bool withDomainSharedCookie = false])` is not implemented, calling this method will do nothing Please use the `deleteCookie` method.
