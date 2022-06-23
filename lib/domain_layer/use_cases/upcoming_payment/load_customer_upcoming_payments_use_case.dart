import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading the upcoming payments related to a customer.
class LoadCustomerUpcomingPaymentsUseCase {
  final UpcomingPaymentRepositoryInterface _repository;

  /// Creates a new [LoadCustomerUpcomingPaymentsUseCase].
  const LoadCustomerUpcomingPaymentsUseCase({
    required UpcomingPaymentRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns grouped upcoming payments related to the passed customer id.
  ///
  /// Use the [limit] and [offset] for pagination purposes.
  Future<UpcomingPaymentGroup> call({
    required String customerID,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  }) =>
      _repository.listAllUpcomingPayments(
        customerID: customerID,
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
      );
}
