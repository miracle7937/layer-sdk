import '../../../features/dpa.dart';

/// Use case that checks the user verification step
class CheckUserTaskUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [CheckUserTaskUseCase] instance.
  const CheckUserTaskUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the user task for the provided process key
  Future<List<DPATask>?> call({
    required String processKey,
    String? variable,
    String? variableValue,
    bool forceRefresh = false,
  }) =>
      _repository.getUserTaskDetails(
        processKey: processKey,
        variable: variable,
        variableValue: variableValue,
        forceRefresh: forceRefresh,
      );
}
