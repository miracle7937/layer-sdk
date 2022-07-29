import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [TransferEvaluationDTO]
extension TransferEvaluationDTOMapping on TransferEvaluationDTO {
  /// Maps into a [TransferEvaluation]
  TransferEvaluation toTransferEvaluation() => TransferEvaluation(
        convertedAmount: convertedAmount,
        convertedAmountCurrency: convertedAmountCurrency,
        rate: rate,
        feesAmount: feesAmount,
        feesCurrency: feesCurrency,
        bulkTransferDetails: bulkTransferDetails ?? [],
      );
}
