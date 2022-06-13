import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [CardPreferencesDTO]
extension CardPreferencesDTOMapping on CardPreferencesDTO {
  /// Maps into a [CardPreferences]
  CardPreferences toCardPreferences() => CardPreferences(
        nickname: nickname,
        favorite: favorite,
        isVisible: display,
        alertOnTransaction: alertTxn,
        alertOnPayment: alertPmt,
        alertOnExpiry: alertExpiry,
        showBalance: showBalance,
        alertOnLowCredit: alertLowCredit,
        lowCredit: lowCredit,
      );
}
