import 'package:equatable/equatable.dart';

/// A model representing a transaction qualifying for an offer.
class OfferTransaction extends Equatable {
  /// The description of the transaction.
  final String? description;

  /// The transaction date.
  final DateTime date;

  /// The transaction amount.
  final double transactionAmount;

  /// The reward amount.
  final double rewardAmount;

  /// The transaction currency.
  final String currency;

  /// Creates [OfferTransaction].
  OfferTransaction({
    this.description,
    required this.date,
    required this.transactionAmount,
    required this.rewardAmount,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        description,
        date,
        transactionAmount,
        rewardAmount,
        currency,
      ];
}
