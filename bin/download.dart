import 'dart:core';
import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  var location = Platform.script.toString();
  var isNewFlutter = location.contains(".snapshot");
  if (isNewFlutter) {
    var sp = Platform.script.toFilePath();
    var sd = sp.split(Platform.pathSeparator);
    sd.removeLast();
    var scriptDir = sd.join(Platform.pathSeparator);
    var packageConfigPath = [scriptDir, '..', '..', '..', 'package_config.json'].join(Platform.pathSeparator);
    var jsonString = File(packageConfigPath).readAsStringSync();
    Map<String, dynamic> packages = jsonDecode(jsonString);
    var packageList = packages["packages"];
    String? zoomFileUri;
    for (var package in packageList) {
      if (package["name"] == "zoom_native_sdk") {
        zoomFileUri = package["rootUri"];
        break;
      }
    }
    if (zoomFileUri == null) {
      //print("zoom_native_sdk package not found!");
    
      return;
    }
    location = zoomFileUri;
  }
  if (Platform.isWindows) {
    location = location.replaceFirst("file:///", "");
  } else {
    location = location.replaceFirst("file://", "");
  }
  if (!isNewFlutter) {
    location = location.replaceFirst("/bin/download.dart", "");
  }

  await checkAndDownloadSDK(location);

  //if (kDebugMode) {
    //print('Complete');
  //}
}

Future<void> checkAndDownloadSDK(String location) async {
  var iosSDKFile = '$location/ios/MobileRTC.xcframework/ios-arm64/MobileRTC.framework';
  // = await File(iosSDKFile).exists();

  // if (!exists) {
  await downloadFile(Uri.parse('https://www.dropbox.com/s/qftq0d9un83g0l2/MobileRTC?dl=1'), iosSDKFile);
  // }

  var iosSimulateSDKFile = '$location/ios/MobileRTC.xcframework/ios-x86_64-simulator/MobileRTC.framework';
  //exists = await File(iosSimulateSDKFile).exists();

  // if (!exists) {
  await downloadFile(Uri.parse('https://www.dropbox.com/s/zyv0fcb29nflnli/MobileRTC?dl=1'), iosSimulateSDKFile);
  // }

  var androidCommonLibFile = '$location/android/libs/commonlib.aar';
  //exists = await File(androidCommonLibFile).exists();
  //if (!exists) {
  await downloadFile(Uri.parse('https://www.dropbox.com/s/u3sh55wiwf06h9t/commonlib.aar?dl=1'), androidCommonLibFile);
  //}
  var androidRTCLibFile = '$location/android/libs/mobilertc.aar';
  //exists = await File(androidRTCLibFile).exists();
  //if (!exists) {
  await downloadFile(Uri.parse('https://www.dropbox.com/s/ofsh4untdm22exw/mobilertc.aar?dl=1'), androidRTCLibFile);
  //}
}

Future<void> downloadFile(Uri uri, String savePath) async {
  File destinationFile = await File(savePath).create(recursive: true);

  // if (kDebugMode) {
  //  print('Download ${uri.toString()} to $savePath');
  //  print(destinationFile.path);
  // }
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();
  await response.pipe(destinationFile.openWrite());
}
