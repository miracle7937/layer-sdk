import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The data transfer object that represents a the text properties for a
/// dpa variable.
class DPAVariableTextPropertiesDTO {
  /// The string hex color.
  final String? color;

  /// The text style.
  final DPAVariableTextStyleDTO? textStyle;

  /// Creates a new [DPAVariableTextPropertiesDTO] object.
  const DPAVariableTextPropertiesDTO({
    this.color,
    this.textStyle,
  });

  /// Creates a new [DPAVariableTextPropertiesDTO] from the given JSON.
  factory DPAVariableTextPropertiesDTO.fromJson(Map<String, dynamic> json) =>
      DPAVariableTextPropertiesDTO(
        color: json['color'],
        textStyle: DPAVariableTextStyleDTO.fromRaw(json['font_style']),
      );
}

/// The available text styles for a dpa variable.
class DPAVariableTextStyleDTO extends EnumDTO {
  /// Title XXXL
  static const titleXXXL = DPAVariableTextStyleDTO._('title_xxxl');

  /// Title XXL
  static const titleXXL = DPAVariableTextStyleDTO._('title_xxl');

  /// Title XL
  static const titleXL = DPAVariableTextStyleDTO._('title_xl');

  /// Title L
  static const titleL = DPAVariableTextStyleDTO._('title_l');

  /// Title M
  static const titleM = DPAVariableTextStyleDTO._('title_m');

  /// Title S
  static const titleS = DPAVariableTextStyleDTO._('title_s');

  /// Title XS
  static const titleXS = DPAVariableTextStyleDTO._('title_xs');

  /// Body XXL
  static const bodyXXL = DPAVariableTextStyleDTO._('body_xxl');

  /// Body XL
  static const bodyXL = DPAVariableTextStyleDTO._('body_xl');

  /// Body L
  static const bodyL = DPAVariableTextStyleDTO._('body_l');

  /// Body M
  static const bodyM = DPAVariableTextStyleDTO._('body_m');

  /// Body S
  static const bodyS = DPAVariableTextStyleDTO._('body_s');

  /// Body XS
  static const bodyXS = DPAVariableTextStyleDTO._('body_xs');

  /// Button M
  static const buttonM = DPAVariableTextStyleDTO._('button_m');

  /// Button S
  static const buttonS = DPAVariableTextStyleDTO._('button_s');

  /// Returns all the values available.
  static const List<DPAVariableTextStyleDTO> values = [
    titleXXXL,
    titleXXL,
    titleXL,
    titleL,
    titleM,
    titleS,
    titleXS,
    bodyXXL,
    bodyXL,
    bodyL,
    bodyM,
    bodyS,
    bodyXS,
    buttonM,
    buttonS,
  ];

  const DPAVariableTextStyleDTO._(String value) : super.internal(value);

  /// Creates a new [DPAVariableTextStyleDTO] from a raw text.
  static DPAVariableTextStyleDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'DPAVariableTextStyleDTO{$value}';
}
