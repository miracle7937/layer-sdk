import '../../../features/transfer.dart';
import '../../models.dart';

/// A use case that resends the second factor for a transfer id.
class ResendTransferSecondFactorUseCase {
  final TransferRepositoryInterface _transferRepository;

  /// Creates a new [ResendTransferSecondFactorUseCase] use case.
  const ResendTransferSecondFactorUseCase({
    required TransferRepositoryInterface transferRepository,
  }) : _transferRepository = transferRepository;

  /// Returns a transfer resulting on resending the second factor for the
  /// passed transfer .
  Future<Transfer> call({
    required NewTransfer transfer,
  }) =>
      _transferRepository.resendSecondFactor(
        transfer: transfer,
      );
}
