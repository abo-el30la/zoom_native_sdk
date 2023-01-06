import 'package:flutter/material.dart';

import 'zoom_native_sdk_platform_interface.dart';

class ZoomNativeSdk {
  Future<bool?> initZoom({
    required String appKey,
    required String appSecret,
  }) {
    debugPrint("ZoomNatively-initZoom");

    return ZoomNativeSdkPlatform.instance.initZoom(
      appKey: appKey,
      appSecret: appSecret,
    );
  }

  Future<bool?> joinMeting(String meetingNumber, String meetingPassword) {
    debugPrint("ZoomNatively-joinMeting $meetingNumber");
    return ZoomNativeSdkPlatform.instance.joinMeting(
      meetingNumber: meetingNumber,
      meetingPassword: meetingPassword,
    );
  }
}
