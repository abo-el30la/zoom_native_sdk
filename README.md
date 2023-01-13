## zoom_native_sdk
this version is initial join zoom meeting using native sdk for android and ios
you need to darg and drop zoom ios meeting sdk manually to your application
# download zoom sdk
```
flutter pub run zoom_native_sdk:download
```
# usage
ios guide to download sdk
[ios docs]https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/getting-started/install-sdk/

```
import 'package:zoom_native_sdk/zoom_native_sdk.dart';
```

```
final _zoomNativelyPlugin = ZoomNativeSdk();
```

```
isInitialized = (await _zoomNativelyPlugin.initZoom(
  appKey: "",
  appSecret: "",
)) ??
false;
```

```
await _zoomNativelyPlugin.joinMeting(
  meetingNumber: "",
  meetingPassword: "",
);
```