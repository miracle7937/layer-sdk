import '../../../features/transfer.dart';

/// A use case that verifies the second factor for a transfer id.
class SendOTPCodeForTransferUseCase {
  final TransferRepositoryInterface _transferRepository;

  /// Creates a new [SendOTPCodeForTransferUseCase] use case.
  const SendOTPCodeForTransferUseCase({
    required TransferRepositoryInterface transferRepository,
  }) : _transferRepository = transferRepository;

  /// Returns a transfer resulting on sending the OTP code for the
  /// passed transfer id.
  Future<Transfer> call({
    required int transferId,
    required bool editMode,
  }) =>
      _transferRepository.sendOTPCode(
        transferId: transferId,
        editMode: editMode,
      );
}
