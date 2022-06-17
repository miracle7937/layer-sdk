import '../../../features/dpa.dart';

/// Use case that claims a task for the current user.
class ClaimDPATaskUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ClaimDPATaskUseCase] instance.
  const ClaimDPATaskUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Claims a task for the current user.
  ///
  /// Returns true if succeeded.
  Future<bool> call({
    required String taskId,
  }) =>
      _repository.claimTask(
        taskId: taskId,
      );
}
