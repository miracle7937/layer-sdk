import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that parses a JSON into a [DPAProcessStepProperties]
/// received when a process is finished and a [DPATask] is returned inside the
/// [DPAProcess.returnVariables], meaning that an old [DPAProcess] should be
/// continued.
class ParseJSONIntoStepPropertiesUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ParseJSONIntoStepPropertiesUseCase]
  const ParseJSONIntoStepPropertiesUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Parses the JSON into a [DPATask] and returns it.
  DPAProcessStepProperties call({
    required Map<String, dynamic> json,
  }) =>
      _repository.parseJSONIntoStepProperties(
        json: json,
      );
}
