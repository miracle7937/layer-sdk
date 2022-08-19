import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

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
      final models = await _loadAsset();
      final info = await _deviceInfoPlugin.iosInfo;
      model = _getPhoneModelName(models, info.utsname.machine);
    }

    return model;
  }

  String _getPhoneModelName(String models, String modelName) {
    if (models.isEmpty || modelName.isEmpty) return '';

    final phonesListSplit = models.split('\n');

    for (final phone in phonesListSplit) {
      if (phone.split(" ")[0] == modelName.toString()) {
        return phone.split(": ")[1].toString();
      }
    }

    return modelName;
  }

  Future<String> _loadAsset() async {
    try {
      return await rootBundle.loadString('assets/iOSDevicesNames.txt');
    } on Exception catch (error) {
      return error.toString();
    }
  }
}
