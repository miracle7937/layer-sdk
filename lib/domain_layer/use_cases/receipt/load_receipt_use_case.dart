import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for loading receipt.
class LoadReceiptUseCase {
  final ReceiptRepositoryInterface _repository;

  /// Creates a new [LoadReceiptUseCase] instance.
  const LoadReceiptUseCase({
    required ReceiptRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns list of [bytes] of receipt
  /// for specified [objectId] of provided [actionType].
  Future<List<int>> call({
    required String objectId,
    required ReceiptActionType actionType,
    ReceiptType type = ReceiptType.image,
  }) async =>
      _repository.getReceipt(
        objectId: objectId,
        actionType: actionType,
        type: type,
      );
}
