import '../../../features/dpa.dart';

/// Use case that sends a special [DPAVariable] to request a
/// email address change.
class DPAChangeEmailAddressUseCase extends DPAStepOrFinishProcessUseCase {
  /// Creates a new [DPAChangeEmailAddressUseCase] instance.
  const DPAChangeEmailAddressUseCase({
    required DPARepositoryInterface repository,
  }) : super(repository: repository);

  /// Requests a email address change by stepping in the process with the
  /// necessary [DPAVariable].
  Future<DPAProcess> call({
    required DPAProcess process,
    bool chosenValue = false,
  }) async {
    final effectiveProcess = process.copyWith(
      variables: [
        ...process.variables,
        DPAVariable(
          id: 'rectify_email_address',
          type: DPAVariableType.boolean,
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
