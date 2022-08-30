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
  ///
  /// The `editMode` param is defined to update/edit the selected transfer
  /// Case `true` the API will `PATCH` the transfer
  Future<Transfer> call({
    required NewTransfer transfer,
    required bool editMode,
  }) =>
      _transferRepository.submit(
        transfer: transfer,
        editMode: editMode,
      );
}
