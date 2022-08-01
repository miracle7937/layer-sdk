import '../../../features/transfer.dart';
import '../../models.dart';

/// A use case that evaluates a transfer
class EvaluateTransferUseCase {
  final TransferRepositoryInterface _transferRepository;

  /// Creates a new [EvaluateTransferUseCase] use case.
  const EvaluateTransferUseCase({
    required TransferRepositoryInterface transferRepository,
  }) : _transferRepository = transferRepository;

  /// Return the transfer evaluation from a transfer object.
  Future<TransferEvaluation> call({
    required NewTransfer transfer,
  }) =>
      _transferRepository.evaluate(
        newTransferPayloadDTO: transfer.toNewTransferPayloadDTO(),
      );
}
