import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_native_sdk/zoom_native_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _zoomNativelyPlugin = ZoomNativeSdk();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    try {
      if (!isInitialized) {
        isInitialized = (await _zoomNativelyPlugin.initZoom(
              appKey: "",
              appSecret: "",
            )) ??
            false;
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              debugPrint("joinMeting -> isInitialized = $isInitialized");
              if (isInitialized) {
                await _zoomNativelyPlugin.joinMeting(
                  meetingNumber: "",
                  meetingPassword: "",
                );
              }
            },
            child: const Text("join"),
          ),
        ),
      ),
    );
  }
}
