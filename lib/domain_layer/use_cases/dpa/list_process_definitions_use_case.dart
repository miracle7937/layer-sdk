import '../../../features/dpa.dart';

/// Use case that lists the process definitions that can be started by
/// the logged in user.
class ListProcessDefinitionsUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ListProcessDefinitionsUseCase] instance.
  const ListProcessDefinitionsUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Lists the process definitions that can be started by the logged in user.
  ///
  /// When [filterSuspended] is `true`, the list will not include any
  /// process marked as suspended. Defaults to `true`.
  ///
  /// When [onlyLatestVersions] is `true`, we will remove all processes that
  /// have the same key, leaving only the one with the highest version number.
  /// Defaults to `true`.
  Future<List<DPAProcessDefinition>> call({
    bool filterSuspended = true,
    bool onlyLatestVersions = true,
    bool forceRefresh = false,
  }) =>
      _repository.listProcessDefinitions(
        filterSuspended: filterSuspended,
        forceRefresh: forceRefresh,
        onlyLatestVersions: onlyLatestVersions,
      );
}
