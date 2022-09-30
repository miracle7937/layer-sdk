import 'package:equatable/equatable.dart';

///
class MinMaxTransactionAmount extends Equatable {
  ///
  final List<String>? currencies;

  ///
  final double? minAmount;

  ///
  final double? maxAmount;

  /// Creates a new immutable instance of [MinMaxTransactionAmount]
  MinMaxTransactionAmount({
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
