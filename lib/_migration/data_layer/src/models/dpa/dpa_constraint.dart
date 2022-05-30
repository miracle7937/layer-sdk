import 'package:equatable/equatable.dart';

/// Holds the data used to check DPA variables. If they're required, the
/// allowed values, etc.
class DPAConstraint extends Equatable {
  /// If it's required.
  final bool required;

  /// If it's read-only.
  final bool readonly;

  /// The minimum length of a text.
  final int? minLength;

  /// The maximum length of a text.
  final int? maxLength;

  /// Minimum value for numbers.
  final num? minValue;

  /// Maximum value for numbers.
  final num? maxValue;

  /// Minimum value for dates.
  final DateTime? minDateTime;

  /// Maximum value for dates.
  final DateTime? maxDateTime;

  /// The regular expression to use.
  final RegExp? regExp;

  /// Creates a new [DPAConstraint].
  const DPAConstraint({
    this.required = false,
    this.readonly = false,
    this.minLength,
    this.maxLength,
    this.minValue,
    this.maxValue,
    this.minDateTime,
    this.maxDateTime,
    this.regExp,
  });

  @override
  List<Object?> get props => [
        required,
        readonly,
        minLength,
        maxLength,
        minValue,
        maxValue,
        minDateTime,
        maxDateTime,
        regExp,
      ];

  /// Creates a new [DPAConstraint] using another as a base.
  DPAConstraint copyWith({
    bool? required,
    bool? readonly,
    int? minLength,
    int? maxLength,
    num? minValue,
    num? maxValue,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    String? allowedCharacters,
    RegExp? regExp,
  }) =>
      DPAConstraint(
        required: required ?? this.required,
        readonly: readonly ?? this.readonly,
        minLength: minLength ?? this.minLength,
        maxLength: maxLength ?? this.maxLength,
        minValue: minValue ?? this.minValue,
        maxValue: maxValue ?? this.maxValue,
        minDateTime: minDateTime ?? this.minDateTime,
        maxDateTime: maxDateTime ?? this.maxDateTime,
        regExp: regExp ?? this.regExp,
      );
}
