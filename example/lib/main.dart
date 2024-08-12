import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_cookie_jar/webview_cookie_jar.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: WebViewWidget(
                      controller: controller,
                    ),
                  ),
                  CupertinoButton(
                    child: const Text("Get Cookie By Dart"),
                    onPressed: () async {
                      final cookies = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse("https://flutter.dev"));
                      if (context.mounted == false) {
                        return;
                      }
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Cookies"),
                                    ...cookies.map((e) => Text(e.toString())),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Dismiss"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  CupertinoButton(
                    child: const Text("Get Cookie By WebView"),
                    onPressed: () {
                      controller.runJavaScriptReturningResult("document.cookie").then((value) {
                        if (context.mounted == false) {
                          return;
                        }
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return Center(
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Cookies"),
                                      Text(value.toString().split(";").join("\n"), textAlign: TextAlign.center),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Dismiss"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      });
                    },
                  ),
                  CupertinoButton(
                    child: const Text("Set Cookie By Dart"),
                    onPressed: () async {
                      final cookie = Cookie("cookie1", "value1");
                      cookie.domain = "flutter.dev";
                      cookie.path = "/";
                      cookie.httpOnly = false;
                      cookie.secure = true;
                      await WebViewCookieJar.cookieJar.saveFromResponse(Uri.parse("https://flutter.dev"), [cookie]);
                    },
                  ),
                  CupertinoButton(
                    child: const Text("Set Cookie By WebView"),
                    onPressed: () {
                      controller.runJavaScript("document.cookie = 'cookie2=value2; domain=flutter.dev; path=/; secure';");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
