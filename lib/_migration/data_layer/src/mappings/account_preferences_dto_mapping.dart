import '../../models.dart';
import '../dtos.dart';

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
