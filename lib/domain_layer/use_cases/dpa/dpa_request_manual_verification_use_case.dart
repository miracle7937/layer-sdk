import '../../../features/dpa.dart';

/// Use case that sends a special [DPAVariable] to request a
/// manual code verification.
class DPARequestManualVerificationUseCase
    extends DPAStepOrFinishProcessUseCase {
  /// Creates a new [DPARequestManualVerificationUseCase] instance.
  const DPARequestManualVerificationUseCase({
    required DPARepositoryInterface repository,
  }) : super(repository: repository);

  /// Requests a manual verification by stepping in the process with the
  /// necessary [DPAVariable].
  Future<DPAProcess> call({
    required DPAProcess process,
    bool chosenValue = false,
  }) async {
    final effectiveProcess = process.copyWith(
      variables: [
        ...process.variables,
        DPAVariable(
          id: 'enter_code',
          type: DPAVariableType.text,
          value: true,
          property: DPAVariableProperty(),
        ),
      ],
    );

    return super.call(
      process: effectiveProcess,
      chosenValue: chosenValue,
    );
  }
}
