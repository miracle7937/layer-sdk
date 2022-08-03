import '../../abstract_repositories.dart';

/// Use case to cancel some [Activity]
class CancelActivityUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [LoadActivitiesUseCase] instance
  CancelActivityUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to cancel the [Activity]
  Future<dynamic> call(String id, {String? otpValue}) => _repository.cancel(
        id,
        otpValue: otpValue,
      );
}
