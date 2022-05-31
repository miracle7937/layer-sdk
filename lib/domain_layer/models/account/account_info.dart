import 'package:equatable/equatable.dart';

/// The account type type
enum AccountType {
  /// Currency account type
  current,

  /// Term Deposit account type
  termDeposit,

  /// Credit Card account type
  creditCard,

  /// Loan account type
  loan,

  /// Securities account type
  securities,

  /// Finance (islamic) account type
  finance,

  /// Savings account type
  savings,

  /// Trade finance account type
  tradeFinance,
}

/// Holds all the account type info
class AccountInfo extends Equatable {
  /// The type of the account
  /// See [AccountType] for more details
  final AccountType? accountType;

  /// The family of the account
  final String? family;

  /// The short account name
  final String? accountName;

  /// The account description or long name
  final String? accountDescription;

  /// Creates a new instance of [AccountInfo]
  AccountInfo({
    this.accountType,
    this.family,
    this.accountName,
    this.accountDescription,
  });

  @override
  List<Object?> get props => [
        accountType,
        family,
        accountName,
        accountDescription,
      ];
}
