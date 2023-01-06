import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoom_native_sdk/zoom_native_sdk_method_channel.dart';

void main() {
  MethodChannelZoomNativeSdk platform = MethodChannelZoomNativeSdk();
  const MethodChannel channel = MethodChannel('zoom_native_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //expect(await platform.getPlatformVersion(), '42');
  });
}
