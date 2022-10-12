import '../../../features/dpa.dart';

/// Use case that checks the user verification step
class CheckVerificationStepUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [CheckVerificationStepUseCase] instance.
  const CheckVerificationStepUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a bool, true if the array is not empty,
  /// which means that the user has a visa verification
  /// application already sent to the bank
  Future<bool> call({
    String? processKey,
    String? variable,
    String? variableValue,
    bool forceRefresh = false,
  }) =>
      _repository.userHasVerificationSent(
        processKey: processKey,
        variable: variable,
        variableValue: variableValue,
        forceRefresh: forceRefresh,
      );
}
