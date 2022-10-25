import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that parses a JSON into a [DPATask] received when a process
/// is finished and a [DPATask] is returned inside the
/// [DPAProcess.returnVariables], meaning that an old [DPAProcess] should be
/// continued.
class ParseJSONIntoDPATaskToContinueDPAProcessUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ParseJSONIntoDPATaskToContinueDPAProcessUseCase]
  const ParseJSONIntoDPATaskToContinueDPAProcessUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Parses the JSON into a [DPATask] and returns it.
  DPATask call({
    required Map<String, dynamic> json,
  }) =>
      _repository.parseJSONIntoDPATask(
        json: json,
      );
}
