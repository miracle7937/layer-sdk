import '../../../features/transfer.dart';
import '../../models.dart';

/// A use case that verifies the second factor for a transfer id.
class VerifyTransferSecondFactorUseCase {
  final TransferRepositoryInterface _transferRepository;

  /// Creates a new [VerifyTransferSecondFactorUseCase] use case.
  const VerifyTransferSecondFactorUseCase({
    required TransferRepositoryInterface transferRepository,
  }) : _transferRepository = transferRepository;

  /// Returns a transfer resulting on verifying the otp for the
  /// passed transfer id.
  Future<Transfer> call({
    required int transferId,
    required String otpValue,
    required SecondFactorType secondFactorType,
  }) =>
      _transferRepository.verifySecondFactor(
        transferId: transferId,
        otpValue: otpValue,
        secondFactorType: secondFactorType,
      );
}
