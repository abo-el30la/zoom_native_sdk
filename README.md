## zoom_native_sdk
this version is initial join zoom meeting using native sdk for android and ios

# download zoom sdk
flutter pub run zoom_native_sdk:download
# using

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