import '../../../features/dpa.dart';

/// Use case that Advances the given [DPAProcess] to the next step, or,
/// in case it's already on the final step, finish it.
class DPAStepOrFinishProcessUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [DPAStepOrFinishProcessUseCase] instance.
  const DPAStepOrFinishProcessUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Advances the given [DPAProcess] to the next step, or, in case it's already
  /// on the final step, finish it.
  ///
  /// Use the `chosenValue` parameter to define whether or not a DPA value was
  /// selected by the user in the current [DPAProcess].
  ///
  /// Use the `extraVariables` parameter for adding extra variables.
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> call({
    required DPAProcess process,
    bool chosenValue = false,
    List<DPAVariable>? extraVariables,
  }) =>
      _repository.stepOrFinishProcess(
        process: process.copyWith(
          variables: [
            ...process.variables,
            ...extraVariables ?? [],
          ],
        ),
        chosenValue: chosenValue,
      );
}
