import '../../abstract_repositories.dart';

/// Use case that requests the receipt file of a account top up.
class GetAccountTopUpReceiptUseCase {
  final AccountRepositoryInterface _repository;

  /// Creates a new [GetAccountTopUpReceiptUseCase] instance.
  GetAccountTopUpReceiptUseCase({
    required AccountRepositoryInterface repository,
  }) : _repository = repository;

  /// Requests a top up receipt with the provided parameters.
  Future<List<int>> call({
    required String topUpId,
    required ReceiptType type,
  }) =>
      _repository.getTopUpReceipt(
        topUpId: topUpId,
        type: type,
      );
}
