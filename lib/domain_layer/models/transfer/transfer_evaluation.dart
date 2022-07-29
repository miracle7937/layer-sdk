import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

///The transfer evaluation from a transfer object.
class TransferEvaluation extends Equatable {
  /// The converted amount.
  final num? convertedAmount;

  /// The converted amount currency.
  final String? convertedAmountCurrency;

  /// The currency exchange rate for this transfer's fees.
  final num? rate;

  /// The fees amount
  final double? feesAmount;

  /// The currency of the fees.
  final String? feesCurrency;

  /// The bulk transfer details.
  final UnmodifiableListView<dynamic> bulkTransferDetails;

  ///Creates a new immutable [TransferEvaluation]
  TransferEvaluation({
    this.convertedAmount,
    this.convertedAmountCurrency,
    this.rate,
    this.feesAmount,
    this.feesCurrency,
    Iterable<dynamic> bulkTransferDetails = const <dynamic>[],
  }) : bulkTransferDetails = UnmodifiableListView(bulkTransferDetails);

  @override
  List<Object?> get props => [
        convertedAmount,
        convertedAmountCurrency,
        rate,
        feesAmount,
        feesCurrency,
        bulkTransferDetails,
      ];
}
