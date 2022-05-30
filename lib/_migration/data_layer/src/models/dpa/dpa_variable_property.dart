import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

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
    Iterable<String>? allowedTypes,
  }) : allowedTypes = UnmodifiableSetView(allowedTypes?.toSet() ?? <String>{});

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
      );
}
