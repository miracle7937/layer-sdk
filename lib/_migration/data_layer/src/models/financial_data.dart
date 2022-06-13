import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// Keeps the financial data
class FinancialData extends Equatable {
  /// Account type balances
  final UnmodifiableMapView<AccountType, double> accountTypeBalances;

  /// Card category balances
  final UnmodifiableMapView<CardCategory, double> cardCategoryBalances;

  /// Available credit
  final double? availableCredit;

  /// Remaining balance
  final double? remainingBalance;

  /// Upcoming payments
  final double? upcomingPayments;

  /// Card balance
  final double? cardBalance;

  /// Pref currency
  final String? prefCurrency;

  /// Whether or not the values of this [FinancialData] should be hidden.
  final bool hideValues;

  /// Creates a new [FinancialData]
  FinancialData({
    Map<AccountType, double> accountTypeBalances =
        const <AccountType, double>{},
    Map<CardCategory, double> cardCategoryBalances =
        const <CardCategory, double>{},
    this.availableCredit,
    this.remainingBalance,
    this.upcomingPayments,
    this.cardBalance,
    this.prefCurrency,
    this.hideValues = false,
  })  : accountTypeBalances = UnmodifiableMapView(accountTypeBalances),
        cardCategoryBalances = UnmodifiableMapView(cardCategoryBalances);

  /// Creates a new instance of [Experience] based on this one.
  FinancialData copyWith({
    Map<AccountType, double>? accountTypeBalances,
    Map<CardCategory, double>? cardCategoryBalances,
    double? availableCredit,
    double? remainingBalance,
    double? upcomingPayments,
    double? cardBalance,
    String? prefCurrency,
    bool? hideValues,
  }) {
    return FinancialData(
      accountTypeBalances: accountTypeBalances ?? this.accountTypeBalances,
      cardCategoryBalances: cardCategoryBalances ?? this.cardCategoryBalances,
      availableCredit: availableCredit ?? this.availableCredit,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      upcomingPayments: upcomingPayments ?? this.upcomingPayments,
      cardBalance: cardBalance ?? this.cardBalance,
      prefCurrency: prefCurrency ?? this.prefCurrency,
      hideValues: hideValues ?? this.hideValues,
    );
  }

  @override
  List<Object?> get props => [
        accountTypeBalances,
        cardCategoryBalances,
        availableCredit,
        remainingBalance,
        upcomingPayments,
        cardBalance,
        prefCurrency,
        hideValues,
      ];
}
