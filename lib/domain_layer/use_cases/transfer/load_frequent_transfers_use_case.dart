import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to load frequent transfers
class LoadFrequentTransfersUseCase {
  final TransferRepositoryInterface _repository;

  /// Creates a new [LoadFrequentTransfersUseCase] instance
  LoadFrequentTransfersUseCase({
    required TransferRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load frequent transfers
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Transfer>> call({
    int? limit,
    int? offset,
    bool includeDetails = true,
    TransferStatus? status,
    List<TransferType>? types,
  }) =>
      _repository.loadFrequentTransfers(
        limit: limit,
        offset: offset,
        includeDetails: includeDetails,
        status: status,
        types: types,
      );
}
