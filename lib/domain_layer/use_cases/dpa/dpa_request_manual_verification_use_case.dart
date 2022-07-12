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
    List<DPAVariable>? extraVariables,
  }) async {
    extraVariables = [
      DPAVariable(
        id: 'enter_code',
        type: DPAVariableType.boolean,
        value: true,
        property: DPAVariableProperty(),
      ),
      DPAVariable(
        id: 'rectify_email_address',
        type: DPAVariableType.boolean,
        value: false,
        property: DPAVariableProperty(),
      ),
      DPAVariable(
        id: 'timeout',
        type: DPAVariableType.boolean,
        value: false,
        property: DPAVariableProperty(),
      ),
    ];

    return super.call(
      process: process,
      extraVariables: extraVariables,
    );
  }
}
