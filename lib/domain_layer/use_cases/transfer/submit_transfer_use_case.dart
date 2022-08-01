import '../../../features/transfer.dart';
import '../../models.dart';

/// A use case that submits a transfer
class SubmitTransferUseCase {
  final TransferRepositoryInterface _transferRepository;

  /// Creates a new [SubmitTransferUseCase] use case.
  const SubmitTransferUseCase({
    required TransferRepositoryInterface transferRepository,
  }) : _transferRepository = transferRepository;

  /// Return the transfer object obtained from submitting a transfer object.
  Future<Transfer> call({
    required NewTransfer transfer,
  }) =>
      _transferRepository.submit(
        transfer: transfer,
      );
}
