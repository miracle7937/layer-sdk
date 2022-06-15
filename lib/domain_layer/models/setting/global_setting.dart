import 'package:equatable/equatable.dart';

/// A model representing a global console setting.
///
/// The type parameter [T] depends on the setting [type].
class GlobalSetting<T> extends Equatable {
  /// The setting code.
  final String code;

  /// The setting module.
  final String module;

  /// The setting value.
  final T value;

  /// The setting type.
  final GlobalSettingType type;

  /// Creates [GlobalSetting].
  GlobalSetting({
    required this.code,
    required this.module,
    required this.value,
    required this.type,
  });

  @override
  List<Object?> get props => [
        code,
        module,
        value,
        type,
      ];
}

/// The setting type.
enum GlobalSettingType {
  /// The value is either `true` or `false`.
  bool,

  /// The value is an `int`.
  int,

  /// The value is a `double`.
  double,

  /// The value is a `String`.
  string,

  /// The value is a `List<String>`.
  list,
}
