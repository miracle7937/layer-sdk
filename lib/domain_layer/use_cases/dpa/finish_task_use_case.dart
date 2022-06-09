import '../../../features/dpa.dart';

/// Use case that finishes the provided [DPATask].
class FinishTaskUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [FinishTaskUseCase] instance.
  const FinishTaskUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Pass the task to finish it.
  ///
  /// Returns `true` if successful.
  Future<bool> call({
    required DPATask task,
  }) =>
      _repository.finishTask(task: task);
}
