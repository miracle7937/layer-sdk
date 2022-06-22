import '../../../features/dpa.dart';

/// Use case that sends a special [DPAVariable] to request a
/// phone number change.
class DPAChangePhoneNumberUseCase extends DPAStepOrFinishProcessUseCase {
  /// Creates a new [DPAChangePhoneNumberUseCase] instance.
  const DPAChangePhoneNumberUseCase({
    required DPARepositoryInterface repository,
  }) : super(repository: repository);

  /// Requests a phone number change by stepping in the process with the
  /// necessary [DPAVariable].
  Future<DPAProcess> call({
    required DPAProcess process,
    bool chosenValue = false,
  }) async {
    final effectiveProcess = process.copyWith(
      variables: [
        ...process.variables,
        DPAVariable(
          id: 'rectify_mobile_number',
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
