import '../../../features/dpa.dart';

/// Use case that returns all tasks assigned to the user.
class ListUserTasksUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ListUserTasksUseCase] instance.
  const ListUserTasksUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Lists all tasks assigned to the user.
  ///
  /// If the [customerId] is passed, this will return only the tasks related
  /// to the customer id.
  ///
  /// An optional [status] can be passed to filter the tasks.
  ///
  /// [fetchCustomersData] fetches the data for each task customer if true,
  /// which is the default.
  ///
  /// If [forceRefresh] is set to true, the cache will be skipped only
  Future<List<DPATask>> call({
    String? customerId,
    DPAStatus? status,
    bool fetchCustomersData = true,
    bool forceRefresh = false,
  }) =>
      _repository.listUserTasks(
        customerId: customerId,
        fetchCustomersData: fetchCustomersData,
        status: status,
        forceRefresh: forceRefresh,
      );
}
