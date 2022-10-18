import '../../../../data_layer/dtos.dart';
import '../../../../domain_layer/models.dart';

/// Extension that provides mappings for [PreferencesDTO]
extension PreferencesDTOMapping on PreferencesDTO {
  /// Maps into a [Preferences]
  Preferences toPreference() => Preferences(
        hideAccessLevelContainer: hideAccessLevelContainer,
        language: language,
        currency: currency,
        theme: theme,
        orderCard: orderCard ?? false,
        orderAccount: orderAccount ?? false,
        overviewAccountId: overviewAccountId,
      );
}
