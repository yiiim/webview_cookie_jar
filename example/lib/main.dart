import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_cookie_jar/webview_cookie_jar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Cookie> _cookies = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_cookies.map((e) => e.toString()).join("\n")),
              CupertinoButton(
                child: const Text("test"),
                onPressed: () async {
                  DateTime aExpires = DateTime.now().add(const Duration(days: 1));
                  final aDotCom = Uri.parse('https://a.com');
                  var aCookie1 = Cookie("a_cookie1_name", "a_cookie1_value");
                  aCookie1.domain = ".a.com";
                  aCookie1.path = "/a";
                  aCookie1.httpOnly = true;
                  aCookie1.secure = true;
                  aCookie1.expires = aExpires;
                  var aCookie2 = Cookie("a_cookie2_name", "a_cookie2_value");
                  aCookie2.domain = ".a.com";
                  var aCookies = [aCookie1, aCookie2];
                  await WebViewCookieJar.cookieJar.saveFromResponse(aDotCom, aCookies);

                  DateTime bExpires = DateTime.now().add(const Duration(days: 2));
                  final bDotCom = Uri.parse('https://b.com');
                  var bCookie1 = Cookie("b_cookie1_name", "b_cookie1_value");
                  bCookie1.domain = ".b.com";
                  bCookie1.path = "/b";
                  bCookie1.httpOnly = false;
                  bCookie1.secure = false;
                  bCookie1.expires = bExpires;
                  var bCookies = [bCookie1];
                  await WebViewCookieJar.cookieJar.saveFromResponse(bDotCom, bCookies);

                  var aResult = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse('https://a.com/a'));
                  var bResult = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse('https://b.com/b'));
                  print("$aResult\n$bResult");
                },
              ),
              CupertinoButton(
                child: const Text("reload test.com cookies"),
                onPressed: () async {
                  _cookies = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse("https://www.test.com"));
                  setState(() {});
                },
              ),
              CupertinoButton(
                child: const Text("reload test1.com cookies"),
                onPressed: () async {
                  _cookies = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse("https://www.test1.com"));
                  setState(() {});
                },
              ),
              CupertinoButton(
                child: const Text("insert cookies for test.com"),
                onPressed: () async {
                  var cookie1 = Cookie("cookie1_name", "cookie1_value");
                  cookie1.domain = ".test.com";
                  cookie1.domain = ".test.com";
                  cookie1.path = "/a";
                  cookie1.httpOnly = true;
                  cookie1.secure = true;
                  var cookie2 = Cookie("cookie2_name", "cookie2_value");
                  cookie2.domain = ".test.com";
                  var cookies = [cookie1, cookie2];
                  await WebViewCookieJar.cookieJar.saveFromResponse(Uri.parse("https://www.test.com/a"), cookies);
                },
              ),
              CupertinoButton(
                child: const Text("insert cookies for test1.com"),
                onPressed: () async {
                  var cookie1 = Cookie(
                    "cookie1_name",
                    "cookie1_value",
                  );
                  cookie1.domain = ".test1.com";
                  var cookies = [cookie1];
                  await WebViewCookieJar.cookieJar.saveFromResponse(Uri.parse("https://www.test1.com"), cookies);
                },
              ),
              CupertinoButton(
                child: const Text("delete for test.com"),
                onPressed: () async {
                  final cookies = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse("https://www.test.com"));
                  Future.wait(cookies.map(
                    (element) async {
                      await WebViewCookieJar.cookieJar.deleteCookie(
                        Uri.parse("https://www.test.com"),
                        element,
                      );
                    },
                  ));
                },
              ),
              CupertinoButton(
                child: const Text("delete for test1.com"),
                onPressed: () async {
                  final cookies = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse("https://www.test1.com"));
                  Future.wait(cookies.map(
                    (element) async {
                      await WebViewCookieJar.cookieJar.deleteCookie(
                        Uri.parse("https://www.test1.com"),
                        element,
                      );
                    },
                  ));
                },
              ),
              CupertinoButton(
                child: const Text("delete all"),
                onPressed: () async {
                  await WebViewCookieJar.cookieJar.deleteAll();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
