import '../../../features/dpa.dart';

/// Use case that skips the given [DPAProcess] to the next step, or,
/// in case it's already on the final step, finish it.
class DPASkipStepUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [DPASkipStepUseCase] instance.
  const DPASkipStepUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Skips the given [DPAProcess] to the next step, or, in case it's already
  /// on the final step, finish it.
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> call({
    required DPAProcess process,
    List<DPAVariable>? extraVariables,
  }) =>
      _repository.stepOrFinishProcess(
        process: process.copyWith(
          variables: extraVariables,
        ),
      );
}
