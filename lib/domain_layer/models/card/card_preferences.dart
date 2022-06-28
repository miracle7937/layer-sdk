import 'package:equatable/equatable.dart';

/// All the user data needed by the application
class CardPreferences extends Equatable {
  /// Card ID
  final String? cardID;

  /// Pref card nickname
  final String? nickname;

  /// True means card is favorite
  final bool favorite;

  /// Whether or not this card should be listed
  final bool isVisible;

  /// Alert on transactions
  final bool alertOnTransaction;

  /// Alert on payment
  final bool alertOnPayment;

  /// Alert on expiry
  final bool alertOnExpiry;

  /// Whether to show balance or not
  final bool showBalance;

  /// Alert on low credit
  final bool alertOnLowCredit;

  /// Pref low credit amount
  final double? lowCredit;

  /// Creates a new [CardPreferences]
  CardPreferences({
    this.cardID,
    this.nickname,
    this.favorite = false,
    this.isVisible = true,
    this.alertOnTransaction = true,
    this.alertOnPayment = true,
    this.alertOnExpiry = true,
    this.showBalance = true,
    this.alertOnLowCredit = true,
    this.lowCredit,
  });

  @override
  List<Object?> get props => [
        cardID,
        nickname,
        favorite,
        isVisible,
        alertOnTransaction,
        alertOnPayment,
        alertOnExpiry,
        showBalance,
        alertOnLowCredit,
        lowCredit,
      ];
}

/// Returns the Card Preference whose card id
/// is the same as the one passed
extension CardPreferencesExtension on List<CardPreferences> {
  /// Returns the Card Preference
  CardPreferences get(String cardID) => firstWhere(
        (pref) => pref.cardID == cardID,
        orElse: () => CardPreferences(
          cardID: cardID,
        ),
      );
}
