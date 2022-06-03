import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mappings for [PreferencesDTO]
extension PreferencesDTOMapping on PreferencesDTO {
  /// Maps into a [Preferences]
  Preferences toPreference() => Preferences(
        language: language,
        currency: currency,
        theme: theme,
        orderCard: orderCard ?? false,
        orderAccount: orderAccount ?? false,
        overviewAccountId: overviewAccountId,
      );
}
