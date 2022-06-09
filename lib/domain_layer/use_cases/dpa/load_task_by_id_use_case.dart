import '../../../features/dpa.dart';

/// Use case that returns the current task of the process matching provided id.
class LoadTaskByIdUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [LoadTaskByIdUseCase] instance.
  const LoadTaskByIdUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the current task of the process matching provided id.
  Future<DPATask?> call({
    required String processInstanceId,
    bool forceRefresh = false,
  }) =>
      _repository.getTask(
        processInstanceId: processInstanceId,
        forceRefresh: forceRefresh,
      );
}
