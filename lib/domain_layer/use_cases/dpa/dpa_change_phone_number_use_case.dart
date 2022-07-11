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
    List<DPAVariable>? extraVariables,
  }) async {
    extraVariables = [
      DPAVariable(
        id: 'rectify_mobile_number',
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
