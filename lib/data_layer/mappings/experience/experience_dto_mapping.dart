import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mapping from [ExperienceDTO] to [Experience].
extension ExperienceDTOMapping on ExperienceDTO {
  /// Returns an [Experience] built from this [ExperienceDTO].
  Experience toExperience({
    UserDTO? userDTO,
    required String experienceImageURL,
  }) {
    if (experienceId == null) {
      throw MappingException(
        from: ExperienceDTO,
        to: Experience,
        value: this,
        details: '`experienceId` cannot be null',
      );
    }

    return Experience(
      id: experienceId!,
      menuType: menu?.toExperienceMenuType() ?? ExperienceMenuType.sideDrawer,
      pages: UnmodifiableListView<ExperiencePage>(
        pages?.map((page) => page.toExperiencePage(
                experienceImageURL: experienceImageURL)) ??
            [],
      ),
      colors: colors,
      fonts: fonts,
      fontSizes: fontSizes,
      backgroundImageUrl: imageUrl,
      mainLogoUrl: mainLogoUrl,
      symbolLogoUrl: symbolLogoUrl,
      preferences: userDTO?.experiencePreferences?.map(
        (e) => e.toExperiencePreferences(),
      ),
    );
  }
}

/// Extension that provides mapping
/// from [ExperienceMenuTypeDTO] to [ExperienceMenuType].
extension ExperienceMenuTypeDTOMapping on ExperienceMenuTypeDTO {
  /// Returns an [ExperienceMenuType] built from this [ExperienceMenuTypeDTO].
  ExperienceMenuType toExperienceMenuType() {
    switch (this) {
      case ExperienceMenuTypeDTO.tabBarTop:
        return ExperienceMenuType.tabBarTop;
      case ExperienceMenuTypeDTO.tabBarBottom:
        return ExperienceMenuType.tabBarBottom;
      case ExperienceMenuTypeDTO.tabBarBottomWithFocusAndMore:
        return ExperienceMenuType.tabBarBottomWithFocusAndMore;
      case ExperienceMenuTypeDTO.sideDrawer:
        return ExperienceMenuType.sideDrawer;
      case ExperienceMenuTypeDTO.bottomDrawer:
        return ExperienceMenuType.bottomDrawer;
    }
  }
}
