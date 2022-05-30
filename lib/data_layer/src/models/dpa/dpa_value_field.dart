import 'package:equatable/equatable.dart';

/// Holds the field data for [DPAValueDTO].
class DPAValueField extends Equatable {
  /// The label of this field.
  final String label;

  /// The value of this field.
  final dynamic value;

  /// Creates a new [DPAValueField]
  DPAValueField({
    required this.label,
    required this.value,
  });

  @override
  List<Object> get props => [label, value];

  /// Creates a new [DPAValueField] using another as a base.
  DPAValueField copyWith({
    String? label,
    dynamic value,
  }) {
    return DPAValueField(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }
}
