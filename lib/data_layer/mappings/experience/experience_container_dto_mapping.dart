import 'package:collection/collection.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mapping
/// from [ExperienceContainerDTO] to [ExperienceContainer].
extension ExperienceContainerDTOMapping on ExperienceContainerDTO {
  /// Returns an [ExperienceContainer] built from this [ExperienceContainerDTO].
  ExperienceContainer toExperienceContainer({
    required String experienceImageURL,
  }) {
    if ([
      containerId,
      containerName,
      typeCode,
      typeName,
      cardTitle,
    ].contains(null)) {
      throw MappingException(
        from: ExperienceContainerDTO,
        to: ExperienceContainer,
        value: this,
        details: 'One of the required parameters is null',
      );
    }

    return ExperienceContainer(
      id: containerId!,
      name: containerName!,
      typeCode: typeCode!,
      typeName: typeName!,
      title: cardTitle!,
      order: order,
      settings: _mapSettingsWithValues(
        containerId: containerId!,
        experienceImageURL: experienceImageURL,
      ),
      messages: Map<String, String>.from(messages),
    );
  }

  /// Merges [settingDefinitions] with [settingValues]
  /// to be used in the [ExperienceContainer] model.
  ///
  /// Settings with types not defined in [ExperienceSettingType]
  /// will be filtered out.
  UnmodifiableListView<ExperienceSetting> _mapSettingsWithValues({
    required int containerId,
    required String experienceImageURL,
  }) {
    final definitions = settingDefinitions ?? <ExperienceSettingDTO>[];
    return UnmodifiableListView<ExperienceSetting>(
      definitions.map(
        (definition) {
          final type = definition.type?.toExperienceSettingType();

          var value = settingValues[definition.setting];
          if (type == ExperienceSettingType.image) {
            value = '$experienceImageURL/${definition.setting}$containerId.png';
          }

          return type != null && definition.setting != null
              ? ExperienceSetting(
                  setting: definition.setting!,
                  type: type,
                  user: definition.user ?? false,
                  value: value,
                )
              : null;
        },
      ).whereNotNull(),
    );
  }
}

/// Extension that provides mapping
/// from [ExperienceSettingTypeDTO] to [ExperienceSettingType].
extension ExperienceSettingTypeDTOMapping on ExperienceSettingTypeDTO {
  /// Returns an [ExperienceSettingType] built from
  /// this [ExperienceSettingTypeDTOMapping].
  ExperienceSettingType toExperienceSettingType() {
    switch (this) {
      case ExperienceSettingTypeDTO.integer:
        return ExperienceSettingType.integer;

      case ExperienceSettingTypeDTO.string:
        return ExperienceSettingType.string;

      case ExperienceSettingTypeDTO.boolean:
        return ExperienceSettingType.boolean;

      case ExperienceSettingTypeDTO.image:
        return ExperienceSettingType.image;

      case ExperienceSettingTypeDTO.multiChoice:
        return ExperienceSettingType.multiChoice;

      case ExperienceSettingTypeDTO.currencyMultiChoice:
        return ExperienceSettingType.currencyMultiChoice;

      case ExperienceSettingTypeDTO.currencyChoice:
        return ExperienceSettingType.currencyChoice;

      default:
        throw MappingException(
          from: ExperienceSettingTypeDTO,
          to: ExperienceSettingType,
          value: this,
        );
    }
  }
}
