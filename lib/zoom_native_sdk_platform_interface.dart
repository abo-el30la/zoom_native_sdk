import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zoom_native_sdk_method_channel.dart';

abstract class ZoomNativeSdkPlatform extends PlatformInterface {
  /// Constructs a ZoomNativeSdkPlatform.
  ZoomNativeSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZoomNativeSdkPlatform _instance = MethodChannelZoomNativeSdk();

  /// The default instance of [ZoomNativeSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelZoomNativeSdk].
  static ZoomNativeSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZoomNativeSdkPlatform] when
  /// they register themselves.
  static set instance(ZoomNativeSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initZoom({
    required String appKey,
    required String appSecret,
  }) {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  Future<bool?> joinMeting({
    required String meetingNumber,
    required String meetingPassword,
  }) {
    throw UnimplementedError('joinMeting() has not been implemented.');
  }
}
