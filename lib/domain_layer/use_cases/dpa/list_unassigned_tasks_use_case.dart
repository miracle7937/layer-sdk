import '../../../features/dpa.dart';

/// Use case that lists all the tasks not assigned to anyone.
class ListUnassignedTasksUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ListUnassignedTasksUseCase] instance.
  const ListUnassignedTasksUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Lists all the tasks not assigned to anyone.
  ///
  /// If the [customerId] is passed, this will return only the tasks related
  /// to the customer id.
  ///
  /// [fetchCustomersData] fetches the data for each task customer if true,
  /// which is the default.
  ///
  /// If [forceRefresh] is set to true, the cache will be skipped only
  /// when fetching the list.
  Future<List<DPATask>> call({
    bool fetchCustomersData = true,
    bool forceRefresh = false,
    String? customerId,
  }) =>
      _repository.listUnassignedTasks(
        fetchCustomersData: fetchCustomersData,
        forceRefresh: forceRefresh,
        customerId: customerId,
      );
}
