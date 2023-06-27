import '../../../data_layer/extensions.dart';
import '../../models.dart';

/// A use case for normalizing the [DPAVariable]'s values
class NormalizeDPAVariableValueUseCase {
  /// Create a new [NormalizeDPAVariableValueUseCase] instance
  NormalizeDPAVariableValueUseCase();

  /// fix the value of the variable when it is a list to be one concatenated
  /// string.
  String _mapListValue(List<String> list) {
    return list.fold(
      '',
      (prev, value) => prev += (prev.isNotEmpty ? '|' : '') + value,
    );
  }

  /// Returns a list of [DPAVariable]s and normalize their values according to
  /// what's needed.
  List<DPAVariable> call(List<DPAVariable> variables) =>
      variables.map((variable) {
        final originalValue = variable.value;
        final normalizedValue = variable.type.shouldUploadFile
            ? null
            : originalValue is DateTime
                ? originalValue.toDTOString(truncateHours: true)
                : originalValue is List<String>
                    ? _mapListValue(originalValue)
                    : originalValue is DPALinkData
                        ? originalValue.originalText
                        : originalValue;
        return variable.copyWith(value: normalizedValue);
      }).toList();
}
