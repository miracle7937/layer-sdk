import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Category of a [BankingCard]
enum CardCategory {
  /// Debit card
  debit,

  /// Credit card
  credit,

  /// Prepaid card
  prepaid,

  /// Unknown
  unknown,
}

/// Holds the [BankingCard] type information
class CardType extends Equatable {
  /// The category of this card
  final CardCategory category;

  /// Name of the card
  final String? name;

  /// Creates a new [CardType] instance
  const CardType({
    this.category = CardCategory.unknown,
    this.name,
  });

  @override
  List<Object?> get props => [
        category,
        name,
      ];
}
