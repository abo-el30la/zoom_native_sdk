import 'dart:convert';
import 'dart:core';
import 'dart:io';

void main(List<String> args) async {
  var location = Platform.script.toString();
  var isNewFlutter = location.contains(".snapshot");
  if (isNewFlutter) {
    var sp = Platform.script.toFilePath();
    var sd = sp.split(Platform.pathSeparator);
    sd.removeLast();
    var scriptDir = sd.join(Platform.pathSeparator);
    var packageConfigPath = [scriptDir, '..', '..', '..', 'package_config.json']
        .join(Platform.pathSeparator);
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
      print("zoom_native_sdk package not found!");
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

  print('Complete');
}

Future<void> checkAndDownloadSDK(String location) async {
  //final commonlibLinkAndroidGradle = "https://www.dropbox.com/s/h8gq6ewfkn7zsh1/build.gradle?dl=0";
  const commonlibLinkAndroidAar = "https://www.dropbox.com/s/u3sh55wiwf06h9t/commonlib.aar?dl=0";

  //final mobilertcLinkAndroidGradle = "https://www.dropbox.com/s/ui7p1eawaog6ylc/build.gradle?dl=0";
  const mobilertcLinkAndroidAar = "https://www.dropbox.com/s/ofsh4untdm22exw/mobilertc.aar?dl=0";

  var iosSDKFile = '$location/ios/MobileRTC.xcframework/ios-arm64_armv7/MobileRTC.framework/MobileRTC';
  bool exists = await File(iosSDKFile).exists();

  // if (!exists) {
  //   await downloadFile(Uri.parse('https://www.dropbox.com/s/a5vfh2m543t15k8/MobileRTC?dl=1'), iosSDKFile);
  // }

  // var iosSimulateSDKFile = location + '/ios/MobileRTC.xcframework/ios-i386_x86_64-simulator/MobileRTC.framework/MobileRTC';
  // exists = await File(iosSimulateSDKFile).exists();

  // if (!exists) {
  //   await downloadFile(Uri.parse('https://www.dropbox.com/s/alk03qxiolurxf8/MobileRTC?dl=1'), iosSimulateSDKFile);
  // }

  var androidCommonLibFile = './android/libs/commonlib.aar';
  exists = await File(androidCommonLibFile).exists();
  // if (!exists) {
  await downloadFile(Uri.parse(commonlibLinkAndroidAar), androidCommonLibFile);
  // }
  var androidRTCLibFile = './android/libs/mobilertc.aar';
  exists = await File(androidRTCLibFile).exists();
  // if (!exists) {
  await downloadFile(Uri.parse(mobilertcLinkAndroidAar), androidRTCLibFile);
  // }
}

Future<void> downloadFile(Uri uri, String savePath) async {
  print('Download ${uri.toString()} to $savePath');
  File destinationFile = await File(savePath).create(recursive: true);

  final request = await HttpClient().getUrl(uri);
  print(request.connectionInfo?.remoteAddress.toString());
  final response = await request.close();
  await response.pipe(destinationFile.openWrite());
}
