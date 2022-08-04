import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [AccountPreferencesDTO]
extension AccountPreferencesDTOMapping on AccountPreferencesDTO {
  /// Maps into a [AccountPreferences]
  AccountPreferences toAccountPreferences() => AccountPreferences(
        nickname: nickname,
        alertOnTransaction: alertTxn ?? false,
        alertOnLowBalance: alertLowBal ?? false,
        alertOnPayment: alertPmt ?? false,
        lowBalance: lowBal,
        favorite: favorite ?? false,
        isVisible: display ?? false,
        showBalance: showBalance ?? false,
      );
}

/// Extension that provides mappings for [AccountPreferences]
extension AccountPreferencesMapping on AccountPreferences {
  /// Maps into a [AccountPreferencesDTO]
  AccountPreferencesDTO toAccountPreferencesDTO() => AccountPreferencesDTO(
        nickname: nickname,
        alertTxn: alertOnTransaction,
        alertLowBal: alertOnLowBalance,
        alertPmt: alertOnPayment,
        lowBal: lowBalance,
        favorite: favorite,
        display: isVisible,
        showBalance: showBalance,
      );
}
