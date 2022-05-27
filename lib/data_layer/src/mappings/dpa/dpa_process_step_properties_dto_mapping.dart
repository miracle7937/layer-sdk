import 'package:validators/validators.dart';

import '../../../models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [DPAProcessStepPropertiesDTO]
extension DPAProcessStepPropertiesDTOMapping on DPAProcessStepPropertiesDTO {
  /// Maps into a [DPAProcessStepProperties]
  DPAProcessStepProperties toDPAProcessStepProperties(
    DPAMappingCustomData customData,
  ) =>
      DPAProcessStepProperties(
        format: type?.toDPAStepFormat() ?? DPAStepFormat.other,
        screenType: screenType?.toDPAScreenType() ?? DPAScreenType.other,
        confirmLabel: buttonLabel,
        cancelLabel: cancelButtonLabel,
        showSave: showSaveButton ?? false,
        maskedNumber: maskedNumber,
        email: email,
        image: toCompleteImageUrl(customData),
        backgroundUrl: bgImagePath,
        feedback: feedback,
      );

  /// Checks if this [DPAProcessStepPropertiesDTO] has a valid URL and appends
  /// the base URL of the current environment configuration to it.
  ///
  /// Returns the original DTO object if the generated URL is invalid.
  String? toCompleteImageUrl(DPAMappingCustomData customData) {
    if (image?.isEmpty ?? true) {
      return '';
    }

    final baseUrl = customData.fileBaseURL;
    final completeUrl = '$baseUrl/$image';

    if (isURL(completeUrl)) {
      return completeUrl;
    }

    return image;
  }
}

/// Extension that provides mappings for [DPAPropertyTypeDTO]
extension DPAPropertyTypeDTOMapping on DPAPropertyTypeDTO {
  /// Maps into a [DPAStepFormat]
  DPAStepFormat toDPAStepFormat() {
    switch (this) {
      case DPAPropertyTypeDTO.popup:
        return DPAStepFormat.popUp;

      case DPAPropertyTypeDTO.display:
        return DPAStepFormat.display;

      default:
        return DPAStepFormat.other;
    }
  }
}

/// Extension that provides mappings for [DPAScreenTypeDTO]
extension DPAScreenTypeDTOMapping on DPAScreenTypeDTO {
  /// Maps into a [DPAScreenType]
  DPAScreenType toDPAScreenType() {
    switch (this) {
      case DPAScreenTypeDTO.otp:
        return DPAScreenType.otp;

      case DPAScreenTypeDTO.pin:
        return DPAScreenType.pin;

      case DPAScreenTypeDTO.email:
        return DPAScreenType.email;

      case DPAScreenTypeDTO.entitySearch:
        return DPAScreenType.entitySearch;

      case DPAScreenTypeDTO.twoColumns:
        return DPAScreenType.twoColumns;

      default:
        return DPAScreenType.other;
    }
  }
}
