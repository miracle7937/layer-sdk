import '../../../features/experience.dart';

/// UI extensions for [ExperienceStateError].
extension ExperienceStateErrorUIExtension on ExperienceStateError {
  /// Maps this [ExperienceStateError] into a title key.
  String toTitleKey() {
    switch (this) {
      case ExperienceStateError.generic:
      case ExperienceStateError.network:
        return 'generic_error';

      case ExperienceStateError.connectivity:
        return 'connectivity_error';

      default:
        return '';
    }
  }
}
