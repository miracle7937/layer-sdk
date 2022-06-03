import 'package:equatable/equatable.dart';

/// All the user data needed by the application
class AccountPreferences extends Equatable {
  /// The account number
  final String? accountNumber;

  /// The pref nickname
  final String? nickname;

  /// Alert on transactions
  final bool alertOnTransaction;

  /// Alert on low balance
  final bool alertOnLowBalance;

  /// Alert on payment
  final bool alertOnPayment;

  /// Balance threshold to alert as low balance
  final double? lowBalance;

  /// Whether the account is favorite or not
  final bool favorite;

  /// Whether or not this card should be listed
  final bool isVisible;

  /// Pref show balance
  final bool showBalance;

  /// Creates a new [AccountPreferences]
  const AccountPreferences({
    this.accountNumber,
    this.nickname,
    this.alertOnTransaction = true,
    this.alertOnLowBalance = true,
    this.alertOnPayment = true,
    this.lowBalance,
    this.favorite = false,
    this.isVisible = true,
    this.showBalance = true,
  });

  @override
  List<Object?> get props => [
        accountNumber,
        nickname,
        alertOnTransaction,
        alertOnLowBalance,
        alertOnPayment,
        lowBalance,
        favorite,
        isVisible,
        showBalance,
      ];
}

/// Returns the Account Preference whose account number
/// is the same as the one passed
extension AccountPreferencesExtension on List<AccountPreferences> {
  /// Returns the Account Preference
  AccountPreferences get(String accountNumber) => firstWhere(
        (pref) => pref.accountNumber == accountNumber,
        orElse: () => AccountPreferences(
          accountNumber: accountNumber,
        ),
      );
}
