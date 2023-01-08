import 'package:flutter_test/flutter_test.dart';
import 'package:zoom_native_sdk/zoom_native_sdk_platform_interface.dart';
import 'package:zoom_native_sdk/zoom_native_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZoomNativeSdkPlatform
    with MockPlatformInterfaceMixin
    implements ZoomNativeSdkPlatform {


  @override
  Future<bool?> initZoom({required String appKey, required String appSecret}) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> joinMeting({required String meetingNumber, required String meetingPassword}) {
    throw UnimplementedError();
  }
}

void main() {
  final ZoomNativeSdkPlatform initialPlatform = ZoomNativeSdkPlatform.instance;

  test('$MethodChannelZoomNativeSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZoomNativeSdk>());
  });

}
