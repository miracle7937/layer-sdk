import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [DPAVariableTextPropertiesDTO].
extension DPAVariableTextPropertiesDTOMapping on DPAVariableTextPropertiesDTO {
  /// Maps into a [DPAVariableTextProperties].
  DPAVariableTextProperties toTextProperties() => DPAVariableTextProperties(
        color: color,
        textStyle: textStyle?.toTextStyle(),
      );
}

/// Extension that provides mapping for [DPAVariableTextStyleDTO]
extension DPAVariableTextStyleDTOMapping on DPAVariableTextStyleDTO {
  /// Maps into a [DPAVariableTextStyle]
  DPAVariableTextStyle? toTextStyle() {
    switch (this) {
      case DPAVariableTextStyleDTO.titleXXXL:
        return DPAVariableTextStyle.titleXXXL;

      case DPAVariableTextStyleDTO.titleXXL:
        return DPAVariableTextStyle.titleXXL;

      case DPAVariableTextStyleDTO.titleXL:
        return DPAVariableTextStyle.titleXL;

      case DPAVariableTextStyleDTO.titleL:
        return DPAVariableTextStyle.titleL;

      case DPAVariableTextStyleDTO.titleM:
        return DPAVariableTextStyle.titleM;

      case DPAVariableTextStyleDTO.titleS:
        return DPAVariableTextStyle.titleS;

      case DPAVariableTextStyleDTO.titleXS:
        return DPAVariableTextStyle.titleXS;

      case DPAVariableTextStyleDTO.bodyXXL:
        return DPAVariableTextStyle.bodyXXL;

      case DPAVariableTextStyleDTO.bodyXL:
        return DPAVariableTextStyle.bodyXL;

      case DPAVariableTextStyleDTO.bodyL:
        return DPAVariableTextStyle.bodyL;

      case DPAVariableTextStyleDTO.bodyM:
        return DPAVariableTextStyle.bodyM;

      case DPAVariableTextStyleDTO.bodyS:
        return DPAVariableTextStyle.bodyS;

      case DPAVariableTextStyleDTO.bodyXS:
        return DPAVariableTextStyle.bodyXS;

      case DPAVariableTextStyleDTO.buttonM:
        return DPAVariableTextStyle.buttonM;

      case DPAVariableTextStyleDTO.buttonS:
        return DPAVariableTextStyle.buttonS;

      default:
        return null;
    }
  }
}
