import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The available types of a DPA variable.
///
/// More properties for each can be found in [DPAVariableProperty].
enum DPAVariableType {
  /// Unknown
  unknown,

  /// A simple text.
  text,

  /// A text with multiple lines.
  textArea,

  /// A simple number.
  number,

  /// A slider with number.
  numberSlider,

  /// A boolean value.
  boolean,

  /// A date/time value.
  dateTime,

  /// Dropdown with options to pick
  dropdown,

  /// List of buttons
  listButton,

  /// Radio button of options
  radioButton,

  /// List of checkboxes
  checkboxList,

  /// List of toggles
  toggleList,

  /// An horizontal list of options
  horizontalPicker,

  /// A text with a clickable URL link.
  ///
  /// The value of this variable will be a [DPALinkData] that contains the data
  /// for texts with links.
  ///
  /// The link will be inside [DPAVariable.property], on [link].
  link,

  /// Image upload
  image,

  /// User signature - follows the same flow as Image upload.
  signature,

  /// Search results
  searchResults,

  /// The swipe (Carousel) variable type.
  swipe,

  /// Pin pad view.
  pin,
}

/// Helper extension for [DPAVariableType]
extension DPAVariableTypeExtension on DPAVariableType {
  /// Returns `true` if the type requires a file to be uploaded to the server.
  bool get shouldUploadFile => [
        DPAVariableType.image,
        DPAVariableType.signature,
      ].contains(this);
}

/// The available validation errors
enum DPAValidationError {
  /// If there's no errors for this variable.
  none,

  /// The variable is required, but there's no value set.
  required,

  /// The variable value does not have the minimum allowed length.
  minLength,

  /// The variable value exceeds the maximum allowed length.
  maxLength,

  /// The variable value is less than the minimum value allowed.
  minValue,

  /// The variable value is greater than the maximum value allowed.
  maxValue,

  /// The variable value does not follow the constraint format.
  format,
}

/// Holds the data for a DPA variable.
class DPAVariable extends Equatable {
  /// The variable id.
  final String id;

  /// A key for this variable.
  ///
  /// This is mainly used when uploading files to identify the variable
  /// associated with them.
  final String key;

  /// The constraints for this variable.
  final DPAConstraint constraints;

  /// The label.
  final String? label;

  /// The order this variable should be presented.
  final int? order;

  /// The type of this variable.
  final DPAVariableType type;

  /// The string representation of the [type] as accepted by the backend.
  final String submitType;

  /// The current value for this variable.
  final dynamic value; // TODO: review if we can use generics here.

  /// Extra properties for this variable.
  final DPAVariableProperty property;

  /// List of values that can be used when setting this variable.
  ///
  /// Mostly used on enumerated types.
  final UnmodifiableListView<DPAValue> availableValues;

  /// The validation error.
  final DPAValidationError validationError;

  /// More information about this [DPAVariable].
  ///
  /// Eg: In case this variable is of type Image, this property may contain
  /// the actual file name that was saved on the backend.
  final String extraInformation;

  /// If the variable has a validation error.
  bool get hasValidationError => validationError != DPAValidationError.none;

  /// Creates a new [DPAVariable].
  DPAVariable({
    required this.id,
    this.key = '',
    this.constraints = const DPAConstraint(),
    this.label,
    this.order,
    this.type = DPAVariableType.text,
    this.submitType = 'string',
    this.value,
    Iterable<DPAValue> availableValues = const [],
    required this.property,
    this.validationError = DPAValidationError.none,
    this.extraInformation = '',
  }) : availableValues = UnmodifiableListView<DPAValue>(availableValues);

  @override
  List<Object?> get props => [
        id,
        key,
        constraints,
        label,
        order,
        type,
        submitType,
        value,
        availableValues,
        property,
        validationError,
        extraInformation,
      ];

  /// Creates a new [DPAVariable] using another as a base.
  DPAVariable copyWith({
    String? id,
    String? key,
    DPAConstraint? constraints,
    String? label,
    int? order,
    DPAVariableType? type,
    String? submitType,
    dynamic value,
    bool clearValue = false,
    Iterable<DPAValue>? availableValues,
    DPAVariableProperty? property,
    DPAValidationError? validationError,
    String? extraInformation,
  }) =>
      DPAVariable(
        id: id ?? this.id,
        key: key ?? this.key,
        constraints: constraints ?? this.constraints,
        label: label ?? this.label,
        order: order ?? this.order,
        type: type ?? this.type,
        submitType: submitType ?? this.submitType,
        value: clearValue ? null : (value ?? this.value),
        availableValues: availableValues ?? this.availableValues,
        property: property ?? this.property,
        validationError: validationError ?? this.validationError,
        extraInformation: extraInformation ?? this.extraInformation,
      );

  /// Creates a new [DPAVariable] using another as a base, and validates it.
  DPAVariable validateAndCopyWith({
    String? id,
    String? key,
    DPAConstraint? constraints,
    String? label,
    int? order,
    DPAVariableType? type,
    String? submitType,
    dynamic value,
    bool clearValue = false,
    Iterable<DPAValue>? availableValues,
    DPAVariableProperty? property,
    String? extraInformation,
  }) {
    final variable = DPAVariable(
      id: id ?? this.id,
      key: key ?? this.key,
      constraints: constraints ?? this.constraints,
      label: label ?? this.label,
      order: order ?? this.order,
      type: type ?? this.type,
      submitType: submitType ?? this.submitType,
      value: clearValue ? null : (value ?? this.value),
      availableValues: availableValues ?? this.availableValues,
      property: property ?? this.property,
      extraInformation: extraInformation ?? this.extraInformation,
    );

    return variable.copyWith(
      validationError: _validate(variable),
    );
  }

  /// Checks if the value for this variable is acceptable.
  static DPAValidationError _validate(DPAVariable v) {
    if (v.type.shouldUploadFile && v.value != null) {
      return DPAValidationError.none;
    }

    if (v.value == null) {
      return v.constraints.required
          ? DPAValidationError.required
          : DPAValidationError.none;
    }

    final numberTypes = [
      DPAVariableType.number,
      DPAVariableType.numberSlider,
    ];

    if (numberTypes.contains(v.type) ||
        (v.property.keyboard == DPAVariableKeyboard.numeric &&
            v.property.dialCodes.isEmpty)) {
      final numValue = v.value is num ? v.value : num.tryParse(v.value);

      if (numValue != null) {
        if (numValue < (v.constraints.minValue ?? double.negativeInfinity)) {
          return DPAValidationError.minValue;
        }

        if (numValue > (v.constraints.maxValue ?? double.infinity)) {
          return DPAValidationError.maxValue;
        }
      }
    }

    if (v.value is String) {
      final stringValue = v.value!.toString();

      if (stringValue.isEmpty && v.constraints.required) {
        return DPAValidationError.required;
      }

      if (stringValue.length < (v.constraints.minLength ?? 0)) {
        return DPAValidationError.minLength;
      }

      if (stringValue.length > (v.constraints.maxLength ?? double.infinity)) {
        return DPAValidationError.maxLength;
      }

      if (!(v.constraints.regExp?.hasMatch(stringValue) ?? true)) {
        return DPAValidationError.format;
      }
    }

    return DPAValidationError.none;
  }
}
