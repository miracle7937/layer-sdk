import '../../../features/dpa.dart';

/// Use case that returns to the previous step of the given [DPAProcess].
class DPAStepBackUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [DPAStepBackUseCase] instance.
  const DPAStepBackUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Returns to the previous step of  the given [DPAProcess].
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> call({
    required DPAProcess process,
  }) =>
      _repository.stepBack(
        process: process,
      );
}
