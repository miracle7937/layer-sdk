import 'dart:io';

import 'package:device_info/device_info.dart';

/// Use case used for getting the device mode.
class GetDeviceModelUseCase {
  /// The device info plugin object.
  final _deviceInfoPlugin = DeviceInfoPlugin();

  /// Creates a new [GetDeviceModelUseCase].
  GetDeviceModelUseCase();

  /// Returns the device model.
  Future<String?> call() async {
    String? model;
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      model = info.model;
    } else if (Platform.isIOS) {
      final info = await _deviceInfoPlugin.iosInfo;
      model = info.model;
    }

    return model;
  }
}
