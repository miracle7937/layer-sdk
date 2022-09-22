import '../../abstract_repositories.dart';

/// Use case to cancel some [Activity]
class CancelActivityUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [CancelActivityUseCase] instance
  CancelActivityUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Cancels the activity of the provided id.
  ///
  /// Use the `otpValue` parameter to specify the one time password value.
  Future<void> call({
    required String id,
    String? otpValue,
  }) =>
      _repository.cancel(
        id,
        otpValue: otpValue,
      );
}
