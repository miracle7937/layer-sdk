import '../../helpers.dart';

/// Data transfer object representing a setting defined in the experience sheet.
class ExperienceSettingDTO {
  /// Code of the setting as defined in the experience sheet.
  final String? setting;

  /// Type of the setting as defined in the experience sheet.
  final ExperienceSettingTypeDTO? type;

  /// Whether application users can change the value of this setting.
  final bool? user;

  /// Creates [ExperienceSettingDTO] from a json.
  ExperienceSettingDTO.fromJson(Map<String, dynamic> json)
      : setting = json['setting'],
        user = json['user'] ?? false,
        type = ExperienceSettingTypeDTO.fromJsonValue(
          json['type'],
        );

  /// Creates a list of [ExperienceSettingDTO] from a list of json objects.
  static List<ExperienceSettingDTO> fromJsonList(
      List<Map<String, dynamic>> json) {
    return json.map(ExperienceSettingDTO.fromJson).toList(growable: false);
  }
}

/// Data transfer object representing a type of the setting value.
class ExperienceSettingTypeDTO extends EnumDTO {
  /// Type representing a setting with value of type int.
  static const integer = ExperienceSettingTypeDTO._internal('int');

  /// Type representing a setting with value of type string.
  static const string = ExperienceSettingTypeDTO._internal('string');

  /// Type representing a setting with value of type boolean.
  static const boolean = ExperienceSettingTypeDTO._internal('boolean');

  /// Type representing a setting which value is an image url.
  static const image = ExperienceSettingTypeDTO._internal('image');

  /// Type representing a setting which value is a list of integer choice codes.
  static const multiChoice = ExperienceSettingTypeDTO._internal('multichoice');

  /// Type representing a setting which value is a list of currencies choice
  /// codes.
  static const currencyMultiChoice = ExperienceSettingTypeDTO._internal(
    'currency_multichoice',
  );

  /// Type representing a setting which value a currency
  static const currencyChoice = ExperienceSettingTypeDTO._internal(
    'currency_choice',
  );

  /// Available [ExperienceSettingTypeDTO] values.
  static const List<ExperienceSettingTypeDTO> values = [
    integer,
    string,
    boolean,
    image,
    multiChoice,
    currencyMultiChoice,
    currencyChoice,
  ];

  /// Mapping of the strings returned by the API to the enum values.
  static const Map<String, ExperienceSettingTypeDTO> _jsonValues = {
    'int': ExperienceSettingTypeDTO.integer,
    'string': ExperienceSettingTypeDTO.string,
    'boolean': ExperienceSettingTypeDTO.boolean,
    'image': ExperienceSettingTypeDTO.image,
    'multichoice': ExperienceSettingTypeDTO.multiChoice,
    'currency_multichoice': ExperienceSettingTypeDTO.currencyMultiChoice,
    'currency_choice': ExperienceSettingTypeDTO.currencyMultiChoice,
  };

  const ExperienceSettingTypeDTO._internal(String value)
      : super.internal(value);

  /// Creates [ExperienceSettingTypeDTO] with a specified value
  /// returned by the API.
  ///
  /// Throws if the supplied value does not match any of the types.
  factory ExperienceSettingTypeDTO.fromJsonValue(String value) {
    if (!_jsonValues.containsKey(value)) {
      throw UnsupportedError('Setting type $value is not supported');
    }
    return _jsonValues[value]!;
  }
}
