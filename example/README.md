# zoom_native_sdk example
this version is initial join zoom meeting using native sdk for android and ios
[plug-in package](https://github.com/abo-el30la/zoom_native_sdk)
using
import 'package:zoom_native_sdk/zoom_native_sdk.dart';

final _zoomNativelyPlugin = ZoomNativeSdk();

isInitialized = (await _zoomNativelyPlugin.initZoom(
appKey: "",
appSecret: "",
)) ??
false;

await _zoomNativelyPlugin.joinMeting(
meetingNumber: "",
meetingPassword: "",
);
