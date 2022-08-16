import '../../../layer_sdk.dart';

/// Use case to cancel the scheduled transfer
class CancelRecurringTransferUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [CancelRecurringTransferUseCase] instance
  CancelRecurringTransferUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to cancel the scheduled transfer
  Future<void> call(String id, {String? otpValue}) =>
      _repository.cancelRecurringTransfer(
        id,
        otpValue: otpValue,
      );
}
