import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

/// Holds the property of a DPA variable
class DPAVariablePropertyDTO {
  /// Type of property.
  final PropertyTypeDTO? propertyType;

  /// The current step.
  final String? step;

  /// The current link.
  final String? link;

  /// The display number.
  final int? display;

  /// The format of this variable.
  final DPAFormatDTO? format;

  /// Help message.
  final String? help;

  /// The kind of keyboard to use.
  final KeyboardDTO? keyboard;

  /// The decimals to use.
  final String? decimals;

  /// The allowed characters.
  final String? allowedCharacters;

  /// The error message.
  final String? errorMessage;

  /// If it should encrypt.
  final bool? encrypt;

  /// The regular expression to use.
  final RegExp? propertiesRegExp;

  /// The scroll direction.
  final DPADirectionDTO? direction;

  /// If should display the search bar.
  final bool? searchBar;

  /// If this denotes a password.
  final bool? isPassword;

  /// If should return multiple values.
  final bool? multipleValues;

  /// How the label should be presented.
  final DPALabelTypeDTO? labelType;

  /// A hint message.
  final String? hint;

  /// The prefix.
  final String? prefix;

  /// Address to the icon to use.
  final String? icon;

  /// The image asset path.
  final String? image;

  /// The types that should be allowed for upload.
  ///
  /// The types will be split by commas.
  final List<String>? allowedTypes;

  /// The list of dial codes.
  final List<DPADialCodeDTO>? dialCodes;

  /// The prefix value.
  final String? prefixValue;

  /// An optional description for this variable.
  final String? description;

  /// The text properties for this variable's label.
  final DPAVariableTextPropertiesDTO? labelTextProperties;

  /// The text properties for this variable's value.
  final DPAVariableTextPropertiesDTO? valueTextProperties;

  /// For prefilling a code on a pin screen
  final bool? characterSplit;

  /// Creates a new [DPAVariablePropertyDTO].
  DPAVariablePropertyDTO({
    this.propertyType,
    this.step,
    this.link,
    this.display,
    this.format,
    this.help,
    this.keyboard,
    this.decimals,
    this.allowedCharacters,
    this.errorMessage,
    this.encrypt,
    this.propertiesRegExp,
    this.direction,
    this.hint,
    this.searchBar,
    this.isPassword,
    this.multipleValues,
    this.prefix,
    this.icon,
    this.labelType,
    this.allowedTypes,
    this.image,
    this.dialCodes,
    this.prefixValue,
    this.description,
    this.labelTextProperties,
    this.valueTextProperties,
    this.characterSplit,
  });

  /// Creates a new [DPAVariablePropertyDTO] from the given JSON.
  factory DPAVariablePropertyDTO.fromJson(Map<String, dynamic> json) =>
      DPAVariablePropertyDTO(
        propertyType: PropertyTypeDTO.fromRaw(json['type']),
        step: json['step'],
        link: json['link'],
        display: json['display'],
        format: json['format'] != null
            ? DPAFormatDTO.fromRaw(json['format'])
            : null,
        help: json['help'],
        keyboard: json['keyboard'] != null
            ? KeyboardDTO.fromRaw(json['keyboard'])
            : null,
        decimals: json['decimals'],
        allowedCharacters: json['allowed_chars'],
        errorMessage: json['error_msg'],
        encrypt: json['encrypt'] ?? false,
        propertiesRegExp: json['regex'] != null ? RegExp(json['regex']) : null,
        hint: json['hint'],
        searchBar: json['searchbar'],
        multipleValues: json['multiple_values'] ?? false,
        direction: json['direction'] != null
            ? DPADirectionDTO.fromRaw(json['direction'])
            : DPADirectionDTO.vertical,
        isPassword: json['password'] ?? false,
        prefix: json['prefix'],
        icon: json['icon'],
        labelType: json['label_type'] == null
            ? null
            : DPALabelTypeDTO(json['label_type']),
        allowedTypes: json['allowed_types']?.split(','),
        image: json['image'],
        dialCodes: json['prefix_list'] == null
            ? []
            : DPADialCodeDTO.fromStringList(
                json['prefix_list'],
              ),
        prefixValue: json['prefix_value'],
        description: json['description'],
        labelTextProperties:
            json['label_color'] == null && json['label_font_style'] == null
                ? null
                : DPAVariableTextPropertiesDTO.fromProperties(
                    color: json['label_color'],
                    fontStyle: json['label_font_style'],
                  ),
        valueTextProperties:
            json['value_color'] == null && json['value_font_style'] == null
                ? null
                : DPAVariableTextPropertiesDTO.fromProperties(
                    color: json['value_color'],
                    fontStyle: json['value_font_style'],
                  ),
        characterSplit: json['character_split'],
      );

  @override
  String toString() => 'DPAVariablePropertyDTO{'
      '${propertyType != null ? ' propertyType: $propertyType' : ''}'
      '${step != null ? ' step: $step' : ''}'
      '${link != null ? ' link: $link' : ''}'
      '${display != null ? ' display: $display' : ''}'
      '${format != null ? ' format: $format' : ''}'
      '${help != null ? ' help: $help' : ''}'
      '${keyboard != null ? ' keyboard: $keyboard' : ''}'
      '${decimals != null ? ' decimals: $decimals' : ''}'
      '${allowedCharacters != null ? ' allowedCharacters: '
          '$allowedCharacters' : ''}'
      '${errorMessage != null ? ' errorMessage: $errorMessage' : ''}'
      '${encrypt != null ? ' encrypt: $encrypt' : ''}'
      '${propertiesRegExp != null ? ' propertiesRegExp: '
          '$propertiesRegExp' : ''}'
      '${direction != null ? ' direction: $direction' : ''}'
      '${searchBar != null ? ' searchBar: $searchBar' : ''}'
      ' multipleValues: $multipleValues'
      '${isPassword != null ? ' isPassword: $isPassword' : ''}'
      '${hint != null ? ' hint: $hint' : ''}'
      '${prefix != null ? ' prefix: $prefix' : ''}'
      '${icon != null ? ' icon: $icon' : ''}'
      '${labelType != null ? ' labelType: $labelType' : ''}'
      '${allowedTypes != null ? 'allowedTypes: $allowedTypes ' : ''}'
      '${image != null ? 'image: $image ' : ''}'
      '${dialCodes != null ? 'dialCodes: $dialCodes ' : ''}'
      '${prefixValue != null ? 'prefixValue: $prefixValue ' : ''}'
      '${description != null ? 'description: $description ' : ''}'
      '${characterSplit != null ? 'characterSplit: $characterSplit ' : ''}'
      '${labelTextProperties != null ? 'labelTextProperties: '
          '$labelTextProperties ' : ''}'
      '${valueTextProperties != null ? 'valueTextProperties: '
          '$valueTextProperties ' : ''}'
      '}';
}

/// The type of keyboard to use when entering a variable
class KeyboardDTO extends EnumDTO {
  /// Only digits
  static const numeric = KeyboardDTO._('numeric');

  /// Text
  static const text = KeyboardDTO._('text');

  /// Returns all the values available.
  static const List<KeyboardDTO> values = [numeric, text];

  const KeyboardDTO._(String value) : super.internal(value);

  /// Creates a new [KeyboardDTO] from a raw text.
  static KeyboardDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'KeyboardDTO{$value}';
}

/// The type of this property.
class PropertyTypeDTO extends EnumDTO {
  /// Swipe
  static const swipe = PropertyTypeDTO._('swipe');

  /// Slider with long values
  static const longSlider = PropertyTypeDTO._('slider');

  /// Picker with long values
  static const longPicker = PropertyTypeDTO._('longPicker');

  /// Simple text
  static const textView = PropertyTypeDTO._('textview');

  /// List of buttons
  static const listButton = PropertyTypeDTO._('listbutton');

  /// Text memo
  static const textArea = PropertyTypeDTO._('textarea');

  /// Radio button
  static const radioButton = PropertyTypeDTO._('bullet');

  /// Horizontal list
  static const horizontalList = PropertyTypeDTO._('horizontal_list');

  /// Signature image upload
  static const signature = PropertyTypeDTO._('signature');

  /// Search results
  static const searchResults = PropertyTypeDTO._('search_results');

  /// Country picker
  static const countryPicker = PropertyTypeDTO._('countryPicker');

  /// Returns all the values available.
  static const List<PropertyTypeDTO> values = [
    swipe,
    longPicker,
    longSlider,
    textView,
    listButton,
    textArea,
    radioButton,
    horizontalList,
    signature,
    searchResults,
    countryPicker,
  ];

  const PropertyTypeDTO._(String value) : super.internal(value);

  /// Creates a new [PropertyTypeDTO] from a raw text.
  static PropertyTypeDTO? fromRaw(String? raw) {
    // We transform raw to lowercase as there's a bug with the textArea
    // coming from the backend in certain processes.
    final effectiveRaw = raw?.toLowerCase();

    if (effectiveRaw == null) return null;

    return values.firstWhereOrNull(
      (val) => val.value.toLowerCase() == effectiveRaw,
    );
  }

  @override
  String toString() => 'PropertyTypeDTO{$value}';
}

/// The general format of this variable.
class DPAFormatDTO extends EnumDTO {
  /// Image
  static const image = DPAFormatDTO._('image');

  /// Text area
  static const textArea = DPAFormatDTO._('textArea');

  /// Header
  static const header = DPAFormatDTO._('header');

  /// PIN
  static const pin = DPAFormatDTO._('pin');

  /// Returns all the values available.
  static const List<DPAFormatDTO> values = [
    image,
    textArea,
    header,
    pin,
  ];

  const DPAFormatDTO._(String value) : super.internal(value);

  /// Creates a new [DPAFormatDTO] from a raw text.
  static DPAFormatDTO? fromRaw(String? raw) {
    // We transform raw to lowercase as there's a bug with the textArea
    // coming from the backend in certain processes.
    final effectiveRaw = raw?.toLowerCase();

    if (effectiveRaw == null) return null;

    return values.firstWhereOrNull(
      (val) => val.value.toLowerCase() == effectiveRaw,
    );
  }

  @override
  String toString() => 'DPAFormatDTO{$value}';
}

/// The scroll direction
class DPADirectionDTO extends EnumDTO {
  /// Vertical
  static const vertical = DPADirectionDTO._('vertical');

  /// Horizontal
  static const horizontal = DPADirectionDTO._('horizontal');

  /// Returns all the values available.
  static const List<DPADirectionDTO> values = [vertical, horizontal];

  const DPADirectionDTO._(String value) : super.internal(value);

  /// Creates a new [DPADirectionDTO] from a raw text.
  static DPADirectionDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'DPADirectionDTO{$value}';
}

/// How to display a label
class DPALabelTypeDTO extends EnumDTO {
  /// Regular
  static const regular = DPALabelTypeDTO._('regular');

  /// In bold
  static const bold = DPALabelTypeDTO._('bold');

  /// Returns all the values available.
  static const List<DPALabelTypeDTO> values = [regular, bold];

  const DPALabelTypeDTO._(String value) : super.internal(value);

  /// Creates a new [DPALabelTypeDTO] from a raw text.
  factory DPALabelTypeDTO(String raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => regular,
      );

  @override
  String toString() => 'DPALabelTypeDTO{$value}';
}
