import 'package:equatable/equatable.dart';

import 'account_info.dart';
import 'account_preferences.dart';

/// The current status of the [Account]
enum AccountStatus {
  /// Account is active
  active,

  /// Account is closed
  closed,

  /// Account is dormant
  dormant,

  /// Account is deleted
  deleted,
}

/// Account data used by the application
class Account extends Equatable {
  /// Unique account identifier, SHA-1 of CIF
  final String? id;

  /// The currency used by this account
  final String? currency;

  /// Available balance in the account
  final num? availableBalance;

  /// The current balance of the account
  final num? currentBalance;

  /// Whether the `availableBalance` and `currentBalance` should be shown
  final bool balanceVisible;

  /// The account number of this account
  final String? accountNumber;

  /// The formatted account number
  final String? formattedAccountNumber;

  /// Generic bank defined reference for account
  final String? reference;

  /// The current status of the account
  final AccountStatus? status;

  /// Holds all the information about the account type
  final AccountInfo? accountInfo;

  /// The ID of the branch of this account
  final String? branchId;

  /// The branch ID of this account in the extra
  final String? extraBranchId;

  /// This account's preferences
  final AccountPreferences preferences;

  /// Creates a new immutable [Account]
  Account({
    this.id,
    this.currency,
    this.availableBalance,
    this.currentBalance,
    this.balanceVisible = true,
    this.accountNumber,
    this.formattedAccountNumber,
    this.reference,
    this.status,
    this.accountInfo,
    this.branchId,
    this.extraBranchId,
    this.preferences = const AccountPreferences(),
  });

  @override
  List<Object?> get props => [
        id,
        currency,
        availableBalance,
        currentBalance,
        balanceVisible,
        accountNumber,
        formattedAccountNumber,
        reference,
        status,
        accountInfo,
        branchId,
        extraBranchId,
        preferences
      ];
}
