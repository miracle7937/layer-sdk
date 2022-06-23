import 'package:validators/validators.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

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
        backgroundUrl: bgImagePath == null
            ? null
            : '${customData.fileBaseURL}$bgImagePath',
        feedback: feedback,
        alignment: alignment?.toDPAScreenAlignment() ??
            DPAScreenAlignment.descriptionImage,
        jumioConfig: jumioConfig?.toJumioConfig(),
        delay: delay,
        block: block?.toDPAScreenBlock() ?? DPAScreenBlock.none,
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

/// Extension that provides mappings for [DPAJumioConfigDTO].
extension DPAJumioConfigDTOMapping on DPAJumioConfigDTO {
  /// Maps into a [DPAJumioConfig].
  DPAJumioConfig toJumioConfig() => DPAJumioConfig(
        authorizationToken: authorizationToken,
        dataCenter: dataCenter,
      );
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

/// Extension that provides mappings for [DPAScreenAlignmentDTO].
extension DPAScreenAlignmentDTOMapping on DPAScreenAlignmentDTO {
  /// Maps into a [DPAScreenAlignment].
  DPAScreenAlignment toDPAScreenAlignment() {
    switch (this) {
      case DPAScreenAlignmentDTO.imageDescription:
        return DPAScreenAlignment.imageDescription;

      case DPAScreenAlignmentDTO.descriptionImage:
        return DPAScreenAlignment.descriptionImage;

      default:
        throw MappingException(
          from: DPAScreenAlignmentDTO,
          to: DPAScreenAlignment,
          value: this,
        );
    }
  }
}

/// Extension that provides mappings for [DPAScreenBlockDTO].
extension DPAScreenBlockDTOMapping on DPAScreenBlockDTO {
  /// Maps into a [DPAScreenBlock].
  DPAScreenBlock toDPAScreenBlock() {
    switch (this) {
      case DPAScreenBlockDTO.none:
        return DPAScreenBlock.none;

      case DPAScreenBlockDTO.email:
        return DPAScreenBlock.email;

      default:
        throw MappingException(
          from: DPAScreenBlockDTO,
          to: DPAScreenBlock,
          value: this,
        );
    }
  }
}
