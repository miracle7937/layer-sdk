import '../../abstract_repositories.dart';

/// Use case to validate the transaction pin
class ValidateTransactionPinUseCase {
  final ValidatorRepositoryInterface _repository;

  /// Creates a new [ValidateTransactionPinUseCase] instance
  ValidateTransactionPinUseCase({
    required ValidatorRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to validate transaction pin by `txnPin`
  Future<void> call({
    required String txnPin,
    required String userId,
  }) {
    return _repository.validateTransactionPin(txnPin: txnPin, userId: userId);
  }
}
