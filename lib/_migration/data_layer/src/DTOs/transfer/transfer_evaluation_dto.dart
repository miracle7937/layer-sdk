import '../../helpers.dart';

///Data transfer object representing the transfer evaluation of a transfer
///This contains the exchange rate for the transfer fees
class TransferEvaluationDTO {
  /// The converted amount.
  num? convertedAmount;

  /// The converted amount currency.
  String? convertedAmountCurrency;

  /// The currency exchange rate for this transfer's fees.
  num? rate;

  /// The fees amount
  double? feesAmount;

  /// The currency of the fees.
  String? feesCurrency;

  /// The bulk transfer details.
  List<dynamic>? bulkTransferDetails;

  ///Creates a new [TransferEvaluationDTO]
  TransferEvaluationDTO({
    this.convertedAmount,
    this.convertedAmountCurrency,
    this.feesAmount,
    this.feesCurrency,
    this.rate,
    this.bulkTransferDetails,
  });

  /// Creates a [TransferEvaluationDTO] from a JSON
  factory TransferEvaluationDTO.fromJson(Map<String, dynamic> json) =>
      TransferEvaluationDTO(
        convertedAmount: json['converted_amount'],
        convertedAmountCurrency: json['converted_amount_currency'],
        rate: json['rate'],
        feesAmount: JsonParser.parseDouble(json['fees']),
        feesCurrency: json['currency'],
        bulkTransferDetails: json['bulk_transfer_details'],
      );
}
