import 'package:equatable/equatable.dart';

/// Account Balance
class AccountBalance extends Equatable {
  /// The account balance
  final num? balance;

  /// The period start date
  final String? periodStartDate;

  /// This period end date
  final String? periodEndDate;

  /// The preferred currency
  final String? prefCurrency;

  /// Creates a new immutable instance of [AccountBalance]
  const AccountBalance({
    this.periodEndDate,
    this.periodStartDate,
    this.prefCurrency,
    this.balance,
  });

  @override
  List<Object?> get props => [
        periodEndDate,
        periodStartDate,
        prefCurrency,
        balance,
      ];
}
