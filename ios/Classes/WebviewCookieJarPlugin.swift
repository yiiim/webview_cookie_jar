import Flutter
import UIKit
import WebKit

public class WebviewCookieJarPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "webview_cookie_jar", binaryMessenger: registrar.messenger())
        let instance = WebviewCookieJarPlugin()
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func convertCookieToSetCookieString(_ cookie: HTTPCookie) -> String {
        var setCookieString = "\(cookie.name)=\(cookie.value)"
        setCookieString += "; Path=\(cookie.path)"
        setCookieString += "; Domain=\(cookie.domain)"
        if cookie.isSecure {
            setCookieString += "; Secure"
        }
        if cookie.isHTTPOnly {
            setCookieString += "; HttpOnly"
        }
        if let expiresDate = cookie.expiresDate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            let expiresDateString = dateFormatter.string(from: expiresDate)
            setCookieString += "; Expires=\(expiresDateString)"
        }
        return setCookieString
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "loadForRequest" {
            var results : [String] = []
            if let urlInArgs = call.arguments as? String,
               let url = URL(string: urlInArgs),
               let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                results = cookies.map {
                    return "\($0.name)=\($0.value)"
                }
            }
            result(results)
        } else if call.method == "saveFromResponse" {
            if let mapArgs = call.arguments as? [String: Any],
               let urlInArgs = mapArgs["url"] as? String,
               let url = URL(string: urlInArgs),
               let setCookies = mapArgs["Set-Cookie"] as? [String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie" : setCookies.joined(separator: ", ")], for: url)
                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                for item in cookies {
                    WKWebsiteDataStore.default().httpCookieStore.setCookie(item)
                }
            }
            result(true)
        } else if call.method == "deleteAll" {
            for cookie in HTTPCookieStorage.shared.cookies ?? [] {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                for item in cookies {
                    WKWebsiteDataStore.default().httpCookieStore.delete(item)
                }
            }
            result(true)
        } else if call.method == "delete" {
            if let mapArgs = call.arguments as? [String: Any] {
                let urlInArgs = mapArgs["url"] as? String
                let name = mapArgs["name"] as? String
                let domain = mapArgs["domain"] as? String
                let path = mapArgs["path"] as? String
                if let urlString = urlInArgs ?? domain,
                   let url = URL(string: urlString) {
                    if let cookies = HTTPCookieStorage.shared.cookies(for: url){
                        for item in cookies {
                            if item.name == name && item.domain == domain ?? url.host && item.path == (path ?? "/") {
                                HTTPCookieStorage.shared.deleteCookie(item)
                                WKWebsiteDataStore.default().httpCookieStore.delete(item)
                            }
                        }
                    }
                }
            }
        }
        result("iOS " + UIDevice.current.systemVersion)
    }
}
