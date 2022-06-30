import '../../../features/bills.dart';

/// Use case responsible for fetching the bills of a [Customer].
class LoadCustomerBillsUseCase {
  final BillRepositoryInterface _billRepository;

  /// Creates a new [LoadCustomerBillsUseCase] instance.
  const LoadCustomerBillsUseCase({
    required BillRepositoryInterface repository,
  }) : _billRepository = repository;

  /// Retrieves the list of [Bill]s of the provided `customer id`.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<Bill>> call({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) =>
      _billRepository.list(
        customerId: customerId,
        limit: limit,
        forceRefresh: forceRefresh,
        offset: offset,
      );
}
