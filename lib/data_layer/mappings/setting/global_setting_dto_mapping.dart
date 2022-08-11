import 'package:logging/logging.dart';

import '../../../domain_layer/models/setting/global_setting.dart';
import '../../dtos.dart';

/// Extension that provides mapping for [GlobalSettingDTO]
extension GlobalSettingDTOMapping on GlobalSettingDTO {
  /// Maps a [GlobalSettingDTO] into a [GlobalSetting].
  ///
  /// Returns null for invalid settings.
  GlobalSetting? toGlobalSetting() {
    if ([
      code,
      module,
      value,
      type,
    ].contains(null)) {
      _logSkippedSetting();
      return null;
    }
    switch (type!.toUpperCase()) {
      case 'B':
        return _toGlobalSetting<bool>(
          value: value == 'T',
          type: GlobalSettingType.bool,
        );

      case 'N':
        final numValue = num.tryParse(value ?? '');
        if (numValue is int) {
          return _toGlobalSetting<int>(
            value: numValue,
            type: GlobalSettingType.int,
          );
        } else if (numValue != null) {
          return _toGlobalSetting<double>(
            value: numValue.toDouble(),
            type: GlobalSettingType.double,
          );
        }
        return null;

      case 'S':
        return _toGlobalSetting<String>(
          value: value!,
          type: GlobalSettingType.string,
        );

      case 'L':
        return _toGlobalSetting<List<String>>(
          value: value!.split(','),
          type: GlobalSettingType.list,
        );

      default:
        _logSkippedSetting();
        return null;
    }
  }

  GlobalSetting<T> _toGlobalSetting<T>({
    required T value,
    required GlobalSettingType type,
  }) {
    return GlobalSetting<T>(
      code: code!,
      module: module!,
      value: value,
      type: type,
    );
  }

  void _logSkippedSetting() {
    Logger('GlobalSettingDTOMapping').severe(
      'Global setting '
          '(module: "$module", code: "$code", value: "$value", type: "$type") '
          'is skipped due to missing data',
    );
  }
}
