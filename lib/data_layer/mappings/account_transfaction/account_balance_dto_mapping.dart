import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mapping for [AccountBalanceDTO]
extension AccountBalanceDTOMapping on AccountBalanceDTO {
  /// Maps a [AccountBalanceDTO] instance to a [AccountBalance] model
  AccountBalance toAccountBalance() => AccountBalance(
        balance: balance,
        periodEndDate: periodEndDate,
        periodStartDate: periodStartDate,
        prefCurrency: prefCurrency,
      );
}
