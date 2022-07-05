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
    List<DPAVariable>? extraVariables,
  }) async {
    extraVariables = [
      DPAVariable(
        id: 'rectify_email_address',
        type: DPAVariableType.boolean,
        value: true,
        property: DPAVariableProperty(),
      ),
      DPAVariable(
        id: 'timeout',
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
    ];

    return super.call(
      process: process,
      chosenValue: chosenValue,
      extraVariables: extraVariables,
    );
  }
}
