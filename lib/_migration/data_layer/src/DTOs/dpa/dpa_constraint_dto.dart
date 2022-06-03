/// Holds the constraints for a DPA variable
class DPAConstraintDTO {
  /// If it's read-only.
  final bool? isReadOnly;

  /// The maximum length of a text.
  final String? maxLength;

  /// The minimum length of a text.
  final String? minLength;

  /// If it's required.
  final bool? isRequired;

  /// Minimum value.
  final String? min;

  /// Maximum value.
  final String? max;

  /// Creates a new [DPAConstraintDTO].
  DPAConstraintDTO({
    this.isReadOnly,
    this.maxLength,
    this.minLength,
    this.isRequired,
    this.min,
    this.max,
  });

  /// Creates a new [DPAConstraintDTO] from a JSON.
  factory DPAConstraintDTO.fromJson(Map<String, dynamic> json) =>
      DPAConstraintDTO(
        isReadOnly: json['readonly'] ?? false,
        maxLength: (json['maxlength'])?.toString(),
        minLength: (json['minlength'])?.toString(),
        min: json['min']?.toString(),
        max: json['max']?.toString(),
        isRequired: json['required'] ?? false,
      );

  @override
  String toString() => 'DPAConstraintDTO{'
      '${isReadOnly != null ? ' isReadOnly: $isReadOnly' : ''}'
      '${maxLength != null ? ' maxLength: $maxLength' : ''}'
      '${minLength != null ? ' minLength: $minLength' : ''}'
      '${isRequired != null ? ' isRequired: $isRequired' : ''}'
      '${min != null ? ' min: $min' : ''}'
      '${max != null ? ' max: $max' : ''}'
      '}';
}
