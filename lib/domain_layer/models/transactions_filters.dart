import 'package:equatable/equatable.dart';

/// the filters object for the transactions
class TransactionFilters extends Equatable {
  /// the list of currencies
  final List<String>? currencies;

  /// the min amount for the slider
  final double? minAmount;

  /// the max amount for the slider
  final double? maxAmount;

  /// Creates a new immutable instance of [TransactionFilters]
  TransactionFilters({
    this.currencies,
    this.minAmount,
    this.maxAmount,
  });

  @override
  List<Object?> get props => [
        currencies,
        minAmount,
        maxAmount,
      ];
}
