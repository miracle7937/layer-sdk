import '../../dtos.dart';
import '../../models/experience/experience_page.dart';
import 'experience_container_dto_mapping.dart';

/// Extension that provides mapping
/// from [ExperiencePageDTO] to [ExperiencePage].
extension ExperiencePageDTOMapping on ExperiencePageDTO {
  /// Returns an [ExperiencePage] built from this [ExperiencePageDTO].
  ExperiencePage toExperiencePage() {
    return ExperiencePage(
      title: title,
      icon: icon,
      order: order,
      containers: containers?.map(
            (container) => container.toExperienceContainer(),
          ) ??
          [],
    );
  }
}
