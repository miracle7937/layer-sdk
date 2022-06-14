import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mapping
/// from [ExperiencePageDTO] to [ExperiencePage].
extension ExperiencePageDTOMapping on ExperiencePageDTO {
  /// Returns an [ExperiencePage] built from this [ExperiencePageDTO].
  ExperiencePage toExperiencePage({
    required String experienceImageURL,
  }) =>
      ExperiencePage(
        title: title,
        icon: icon,
        order: order,
        containers: containers?.map(
              (container) => container.toExperienceContainer(
                  experienceImageURL: experienceImageURL),
            ) ??
            [],
      );
}
