import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

/// Util class for getting the device fingerprint and user agent request headers
class RequestHeadersHelper {
  RequestHeadersHelper._();

  /// Returns the device fingerprint for the request headers.
  static Future<String> getDeviceIdentifier() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) return '';

    if (Platform.isAndroid) {
      var info = await deviceInfoPlugin.androidInfo;
      return info.androidId;
    } else if (Platform.isIOS) {
      var info = await deviceInfoPlugin.iosInfo;
      return info.identifierForVendor;
    }
    return '';
  }

  /// Returns the device name.
  static Future<String?> getDeviceName() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) return null;

    if (Platform.isAndroid) {
      var info = await deviceInfoPlugin.androidInfo;
      return info.device;
    } else if (Platform.isIOS) {
      var info = await deviceInfoPlugin.iosInfo;
      return info.name;
    }
    return null;
  }

  /// Returns the device model.
  static Future<String?> getDeviceModel() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) return null;

    if (Platform.isAndroid) {
      var info = await deviceInfoPlugin.androidInfo;
      return info.model;
    } else if (Platform.isIOS) {
      var info = await deviceInfoPlugin.iosInfo;
      return info.model;
    }
    return null;
  }

  /// Returns the user agent for the request headers.
  static Future<String> getUserAgent() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final build = packageInfo.buildNumber;
    late String platformVersion;
    late String os;

    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      platformVersion = androidInfo.version.release;
      os = 'Android';
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      platformVersion = iosInfo.systemVersion;
      os = 'iOS';
    }

    return 'ubanquity/$version build/$build $os/$platformVersion';
  }
}
