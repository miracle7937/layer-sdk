import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../helpers.dart';

/// Extension that provides mappings for [DPAConstraintDTO]
extension DPAConstraintDTOMapping on DPAConstraintDTO {
  /// Maps into a [DPAConstraint]
  DPAConstraint toDPAConstraint(DPAVariablePropertyDTO? property) =>
      DPAConstraint(
        required: isRequired ?? false,
        readonly: isReadOnly ?? false,
        minLength: minLength != null ? int.tryParse(minLength!) : null,
        maxLength: maxLength != null ? int.tryParse(maxLength!) : null,
        minValue: min != null ? num.tryParse(min!) : null,
        maxValue: max != null ? num.tryParse(max!) : null,
        minDateTime: JsonParser.parseDate(min),
        maxDateTime: JsonParser.parseDate(max),
        regExp: property?.propertiesRegExp ??
            (property?.allowedCharacters != null
                ? RegExp('[${property!.allowedCharacters}]')
                : null),
      );
}
