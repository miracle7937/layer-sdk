import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The type of keyboard allowed when entering a DPA variable value.
enum DPAVariableKeyboard {
  /// All text
  text,

  /// Only digits
  numeric,
}

/// How to display the label
enum DPAVariableLabelType {
  /// Regular
  regular,

  /// Display in bold
  bold,
}

/// How to display the picker
enum DPAVariablePicker {
  /// Currency
  currency,

  /// None
  none,
}

/// The type of this DPA Variable property
enum DPAVariablePropertyType {
  /// Search results type.
  searchResults,

  /// Country picker type.
  countryPicker,
}

/// Additional properties for a DPA variable.
class DPAVariableProperty extends Equatable {
  /// The number of discrete divisions.
  final int? step;

  /// A URL to use as a link.
  final String? link;

  /// The display number.
  final int? display;

  /// Help message.
  final String? help;

  /// The kind of keyboard to use.
  final DPAVariableKeyboard? keyboard;

  /// The decimals to use.
  final String? decimals;

  /// The error message.
  final String? errorMessage;

  /// If it should encrypt.
  final bool encrypt;

  /// If this denotes a password.
  final bool isPassword;

  /// If should display a search bar.
  final bool searchBar;

  /// If the text should have multiple lines.
  final bool multiline;

  /// If should return multiple values.
  final bool multipleValues;

  /// How the label should be presented.
  final DPAVariableLabelType? labelType;

  /// A hint message.
  final String? hint;

  /// The prefix.
  final String? prefix;

  /// Address to the icon to use.
  final String? icon;

  /// The DPAVariable property type.
  final DPAVariablePropertyType? type;

  /// The types that should be allowed for upload.
  final UnmodifiableSetView<String> allowedTypes;

  /// The image asset path.
  final String? image;

  /// The list of [DPADialCode] associated with this [DPAVariable].
  final UnmodifiableListView<DPADialCode> dialCodes;

  /// The default dial code
  final String? defaultPrefix;

  /// The prefix value.
  final String? prefixValue;

  /// An optional description for this variable.
  final String? description;

  /// The text properties for this variable's label.
  final DPAVariableTextProperties? labelTextProperties;

  /// The text properties for this variable's value.
  final DPAVariableTextProperties? valueTextProperties;

  /// The currency string for the flag of the variable
  final String? currencyFlagCode;

  /// For prefilling a code on a pin screen
  final bool? characterSplit;

  /// Picker Type
  final DPAVariablePicker? picker;

  /// Label color
  final String? labelColor;

  /// Icon text
  final String? iconUrl;

  /// Label font style
  final String? labelFontStyle;

  /// Whether we need to render the variable on the screen or not
  final bool? show;

  /// Creates a new [DPAVariableProperty].
  DPAVariableProperty({
    this.step,
    this.link,
    this.display,
    this.help,
    this.keyboard,
    this.decimals,
    this.errorMessage,
    this.encrypt = false,
    this.isPassword = false,
    this.searchBar = false,
    this.multiline = false,
    this.multipleValues = false,
    this.labelType,
    this.hint,
    this.prefix,
    this.icon,
    this.type,
    this.image,
    Iterable<String>? allowedTypes,
    Iterable<DPADialCode>? dialCodes,
    this.prefixValue,
    this.description,
    this.labelTextProperties,
    this.valueTextProperties,
    this.currencyFlagCode,
    this.characterSplit,
    this.picker,
    this.defaultPrefix,
    this.labelColor,
    this.iconUrl,
    this.labelFontStyle,
    this.show = false,
  })  : allowedTypes = UnmodifiableSetView(allowedTypes?.toSet() ?? <String>{}),
        dialCodes = UnmodifiableListView(dialCodes ?? []);

  @override
  List<Object?> get props => [
        step,
        link,
        display,
        help,
        keyboard,
        decimals,
        errorMessage,
        encrypt,
        isPassword,
        searchBar,
        multiline,
        multipleValues,
        labelType,
        hint,
        prefix,
        icon,
        type,
        allowedTypes,
        image,
        dialCodes,
        prefixValue,
        description,
        labelTextProperties,
        valueTextProperties,
        currencyFlagCode,
        picker,
        defaultPrefix,
        labelColor,
        iconUrl,
        labelFontStyle,
        show,
      ];

  /// Creates a new [DPAVariableProperty] using another as a base.
  DPAVariableProperty copyWith({
    int? step,
    String? link,
    int? display,
    String? help,
    DPAVariableKeyboard? keyboard,
    String? decimals,
    String? errorMessage,
    bool? encrypt,
    bool? isPassword,
    bool? searchBar,
    bool? multiline,
    bool? multipleValues,
    DPAVariableLabelType? labelType,
    String? hint,
    String? prefix,
    String? icon,
    DPAVariablePropertyType? type,
    Iterable<String>? allowedTypes,
    String? image,
    Iterable<DPADialCode>? dialCodes,
    String? prefixValue,
    String? description,
    DPAVariableTextProperties? labelTextProperties,
    DPAVariableTextProperties? valueTextProperties,
    String? currencyFlagCode,
    bool? characterSplit,
    DPAVariablePicker? picker,
    String? defaultPrefix,
    String? labelColor,
    String? iconUrl,
    String? labelFontStyle,
    bool? show,
  }) =>
      DPAVariableProperty(
        step: step ?? this.step,
        link: link ?? this.link,
        display: display ?? this.display,
        help: help ?? this.help,
        keyboard: keyboard ?? this.keyboard,
        decimals: decimals ?? this.decimals,
        errorMessage: errorMessage ?? this.errorMessage,
        encrypt: encrypt ?? this.encrypt,
        isPassword: isPassword ?? this.isPassword,
        searchBar: searchBar ?? this.searchBar,
        multiline: multiline ?? this.multiline,
        multipleValues: multipleValues ?? this.multipleValues,
        labelType: labelType ?? this.labelType,
        hint: hint ?? this.hint,
        prefix: prefix ?? this.prefix,
        icon: icon ?? this.icon,
        type: type ?? this.type,
        allowedTypes: allowedTypes ?? this.allowedTypes,
        image: image ?? this.image,
        dialCodes: dialCodes ?? this.dialCodes,
        prefixValue: prefixValue ?? this.prefixValue,
        description: description ?? this.description,
        labelTextProperties: labelTextProperties ?? this.labelTextProperties,
        valueTextProperties: valueTextProperties ?? this.valueTextProperties,
        currencyFlagCode: currencyFlagCode ?? this.currencyFlagCode,
        characterSplit: characterSplit ?? this.characterSplit,
        picker: picker ?? this.picker,
        defaultPrefix: defaultPrefix ?? this.defaultPrefix,
        labelColor: labelColor ?? this.labelColor,
        iconUrl: iconUrl ?? this.iconUrl,
        labelFontStyle: labelFontStyle ?? this.labelFontStyle,
        show: show ?? this.show,
      );
}
