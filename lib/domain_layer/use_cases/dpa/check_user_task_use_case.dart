import '../../../features/dpa.dart';

/// Use case that checks the user verification step
class CheckUserTaskUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [CheckUserTaskUseCase] instance.
  const CheckUserTaskUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Returns an array, if the array is not empty, then the
  /// user has a task in progress, if not, then he doesn't
  /// have any task in progress
  Future<List<DPATask>?> call({
    required String processKey,
    bool forceRefresh = false,
  }) =>
      _repository.getUserTaskDetails(
        processKey: processKey,
        forceRefresh: forceRefresh,
      );
}
