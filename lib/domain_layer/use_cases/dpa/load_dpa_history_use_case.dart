import '../../../features/dpa.dart';

/// Use case that lists all previous tasks.
class LoadDPAHistoryUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [LoadDPAHistoryUseCase] instance.
  const LoadDPAHistoryUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Lists all previous tasks.
  ///
  /// [fetchCustomersData] fetches the data for each task customer if true,
  /// which is the default.
  ///
  /// If force refresh is set to true, the cache will be skipped only
  Future<List<DPATask>> call({
    bool fetchCustomersData = true,
    bool forceRefresh = false,
  }) =>
      _repository.listHistory(
        fetchCustomersData: fetchCustomersData,
        forceRefresh: forceRefresh,
      );
}
