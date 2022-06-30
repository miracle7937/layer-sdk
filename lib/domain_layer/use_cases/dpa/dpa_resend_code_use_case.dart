import '../../../features/dpa.dart';

/// Use case that sends a special [DPAVariable] to request a new 2FA code.
class DPAResendCodeUseCase extends DPAStepOrFinishProcessUseCase {
  /// Creates a new [DPAResendCodeUseCase] instance.
  const DPAResendCodeUseCase({
    required DPARepositoryInterface repository,
  }) : super(repository: repository);

  /// Requests a new code by stepping in the process with the
  /// necessary [DPAVariable].
  Future<DPAProcess> call({
    required DPAProcess process,
    bool chosenValue = false,
  }) async {
    final isPhoneOTP = process.stepProperties?.maskedNumber != null;

    final effectiveProcess = process.copyWith(
      variables: [
        ...process.variables,
        DPAVariable(
          id: 'timeout',
          type: DPAVariableType.boolean,
          value: true,
          property: DPAVariableProperty(),
        ),
        DPAVariable(
          id: isPhoneOTP ? 'rectify_mobile_number' : 'rectify_email_address',
          type: DPAVariableType.boolean,
          value: false,
          property: DPAVariableProperty(),
        ),
        DPAVariable(
          id: 'enter_code',
          type: DPAVariableType.boolean,
          value: false,
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
