# zoom_native_sdk

[![Pub](https://img.shields.io/pub/v/zoom_native_sdk.svg)](https://pub.dartlang.org/packages/zoom_native_sdk)
[![likes](https://img.shields.io/pub/likes/zoom_native_sdk)](https://pub.dev/packages/zoom_native_sdk/score)
[![popularity](https://img.shields.io/pub/popularity/zoom_native_sdk)](https://pub.dev/packages/zoom_native_sdk/score)
[![pub points](https://img.shields.io/pub/points/zoom_native_sdk)](https://pub.dev/packages/zoom_native_sdk/score)
[![codecov](https://codecov.io/gh/ABausG/zoom_native_sdk/branch/main/graph/badge.svg?token=ZXTZOL6KFO)](https://codecov.io/gh/ABausG/zoom_native_sdk)

this version is initial join zoom meeting using native sdk for android and ios
you need to drag and drop zoom ios meeting sdk manually to your application

## Platform Setup
In order to work correctly there needs to be some platform specific setup. Check below on how to add support for Android and iOS


<details><summary>Android</summary>
download zoom sdk for android by running this command in terminal

```
flutter pub run zoom_native_sdk:download
```
</details>

<details><summary>iOS</summary>

in first you need to login to your zoom account  then select your project and download  ios sdk.


 <img src="https://i.ibb.co/2yvrtHF/ios-zoom-sdk.webp?raw=true"> 


after download is complete  unzip file and copy  two file  :-
* MobileRTC.xcframework
* MobileRTCResources.bundle

and past in **IOS** module

 <img src="https://i.ibb.co/YtHXtbz/ios-module.png?raw=true" hight="500 px"> 


then open ios in **Xcode** and click right to Runner folder and add two file to it
* MobileRTC.xcframework
* MobileRTCResources.bundle

<img src="https://i.ibb.co/C1c99F6/add-file-to-runner.png?raw=true" hight="500 px"> 
<br /> 

will be shown as this image below

<img src="https://i.ibb.co/z6byskP/xcode-file.png?raw=true" hight="500 px"> 

<br /> 

after adding this files running **pod install** to get pods for zoom in ios

by click right to ios folder and select onpen in terminal

```
pod install
```


after pod install is complete  open xcode  and  make sure **MobileRTC.xcframework**
is added in `TARGETS/Runner/Frameworks,Libraries, and Embedded Content`

<img src="https://i.ibb.co/K21Y3Sg/add-rtc.png?raw=true" hight="500 px"> 

<br /> 

and finally  in xcode go to `Pods/TARGETS/zoom_native_sdk/Frameworks and Libraries`

and add MobileRTC.xcframework to it and make sure it Do Not Embed as shown

<img src="https://i.ibb.co/NYs2Ysz/config-pod.png?raw=true" hight="500 px"> 

for more info
[ios docs](https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/getting-started/install-sdk/)

</details>
<br /> 

### Usage
-------------------------


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



### About Develpment
-------------------------------

develop and maintenance by **Al7osam company**
<p align="center">
<img align="center" src="https://play-lh.googleusercontent.com/T04y6F4hKkzh6fygIF9S45_quM2MmLkOOlKzuAg__uskxQQ9_bxrM0lZ8t8PchRRuS0=w3840-h2160-rw?raw=true" />
</p>
<p align="center">
<a href="https://play.google.com/store/apps/dev?id=8288448436887856501" target="_blank"><img src="https://img.shields.io/badge/Google%20Play-Al7osam-darkred.svg?style=for-the-badge&logo=google&logoColor=white"></a>&nbsp;&nbsp;&nbsp;<a href="https://www.threads.net/@al7osamsolutions" target="_blank"><img src="https://img.shields.io/badge/instagram-@Al7osam-blue.svg?style=for-the-badge&logo=instagram&logoColor=white"></a>
&nbsp;&nbsp;&nbsp;<a href="https://www.facebook.com/Al7osamCompany/" target="_blank"><img src="https://img.shields.io/badge/facebook-Al7osam-darkblue.svg?style=for-the-badge&logo=Facebook&logoColor=white"></a>
 &nbsp;&nbsp;&nbsp;<a href="https://apps.apple.com/eg/developer/al7osam/id1292208382" target="_blank"><img src="https://img.shields.io/badge/apple-Al7osam-orange.svg?style=for-the-badge&logo=Apple&logoColor=white"></a>
<br>
</p>
<br>
