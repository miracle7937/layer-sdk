import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/mappings.dart';
import '../../../../domain_layer/models.dart';
import '../../models.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Extension that provides mapping for [FinancialDataDTO]
extension FinancialDataDTOMapping on FinancialDataDTO {
  /// Maps a [FinancialDataDTO] instance to a [FinancialData] model
  FinancialData toFinancialData() => FinancialData(
        accountTypeBalances: accountTypeBalances?.toFinancialDataAccount() ??
            <AccountType, double>{},
        cardCategoryBalances: cardCategoryBalances?.toFinancialDataCard() ??
            <CardCategory, double>{},
        availableCredit: availableCredit is double ? availableCredit : 0.0,
        remainingBalance: remainingBalance is double ? remainingBalance : 0.0,
        upcomingPayments: upcomingPayments is double ? upcomingPayments : 0.0,
        cardBalance: cardBalance is double ? cardBalance : 0.0,
        prefCurrency: prefCurrency,
        hideValues: [
          availableCredit,
          remainingBalance,
          upcomingPayments,
          cardBalance,
        ].any((element) => element is String),
      );
}

/// Extension that provides mapping for [FinancialDataDTO]
/// accountTypeBalances Map
extension AccountTypeMapDTOMapping on Map<AccountTypeDTOType, double> {
  /// To financial data account map
  Map<AccountType, double> toFinancialDataAccount() => map(
        (e, r) => MapEntry(e.toAccountType(), r),
      );
}

/// Extension that provides mapping for [FinancialDataDTO]
/// cardCategoryBalances Map
extension CardCategoryTypeDTOMapping on Map<CardCategoryDTO, double> {
  /// To financial data account map
  Map<CardCategory, double> toFinancialDataCard() => map(
        (e, r) => MapEntry(e.toCardCategory(), r),
      );
}
