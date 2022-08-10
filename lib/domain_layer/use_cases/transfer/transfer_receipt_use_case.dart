import '../../../features/transfer.dart';

/// A use case that gets the receipt for a transfer id.
class TransferReceiptUseCase {
  final TransferRepositoryInterface _transferRepository;

  /// Creates a new [TransferReceiptUseCase] use case.
  const TransferReceiptUseCase({
    required TransferRepositoryInterface transferRepository,
  }) : _transferRepository = transferRepository;

  /// Returns a receipt belonging the transfer.
  Future<List<int>> call({
    required int transferId,
    bool? isImage,
  }) =>
      _transferRepository.getTransferReceipt(
        transferId: transferId,
        isImage: isImage,
      );
}
