import '../../../domain_layer/models/setting/global_setting.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mapping for [GlobalSettingDTO]
extension GlobalSettingDTOMapping on GlobalSettingDTO {
  /// Maps a [GlobalSettingDTO] into a [GlobalSetting].
  GlobalSetting toGlobalSetting() {
    if ([
      code,
      module,
      value,
      type,
    ].contains(null)) {
      throw MappingException(
        from: GlobalSettingDTO,
        to: GlobalSetting,
        value: this,
        details: 'One of the required parameters is null',
      );
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
        }
        return _toGlobalSetting<double>(
          value: numValue!.toDouble(),
          type: GlobalSettingType.double,
        );

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
        throw UnsupportedError('Setting type $type is not supported');
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
}
