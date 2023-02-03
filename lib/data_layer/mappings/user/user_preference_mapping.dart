import '../../../domain_layer/models.dart';
import '../../../domain_layer/models/user/alert_preference.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides DTO mapping for user preferences.
extension UserPreferenceDTOMapping on UserPreference {
  /// Maps into the [UserPreferenceDTO].
  UserPreferenceDTO toUserPreferenceDTO() {
    if (this is FavoriteOffersPreference) {
      return FavoriteOffersPreferenceDTO(
        value: value as List<int>,
      );
    }

    if (this is AlertPreference) {
      final activityTypes = value as List<ActivityType>;
      return AlertPreferenceDTO(
        value: activityTypes.map((e) => e.toTypeDTO()).toList(),
      );
    }

    if (this is BalanceAlertPreference) {
      return BalanceAlertPreferenceDTO(
        preferenceKey: key,
        preferenceValue: value,
      );
    }

    if (this is CustomUserPreference) {
      return CustomUserPreferenceDTO(
        key: key,
        value: value,
      );
    }

    throw MappingException(
      from: UserPreference,
      to: UserPreferenceDTO,
      value: this,
      details:
          'The DTO mapping for "$runtimeType". This usually means that  a new '
          'type of user preference was added and the mapping was not included '
          'above.',
    );
  }
}
