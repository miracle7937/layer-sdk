import 'package:equatable/equatable.dart';

/// Model representing a setting defined in the experience sheet.
class ExperienceSetting extends Equatable {
  /// Code of the setting as defined in the experience sheet.
  final String setting;

  /// Type of the setting as defined in the experience sheet.
  final ExperienceSettingType type;

  /// Whether application users can change the value of this setting.
  final bool user;

  /// Value of the setting configured in the console.
  ///
  /// The [value] type is dependent on the setting [type].
  /// This field can be null.
  final dynamic value;

  /// Creates [ExperienceSetting].
  ExperienceSetting({
    required this.setting,
    required this.type,
    this.user = false,
    this.value,
  });

  @override
  List<Object?> get props => [
        setting,
        type,
        user,
        value,
      ];
}

/// Possible types of the the setting values.
enum ExperienceSettingType {
  /// Type representing a setting with value of type int.
  integer,

  /// Type representing a setting with value of type string.
  string,

  /// Type representing a setting with value of type boolean.
  boolean,

  /// Type representing a setting which value is an image url.
  image,

  /// Type representing a setting with value of type multichoice.
  multiChoice,
}
