import '../../../features/payments.dart';

/// Use case that loads the list of payments of a [Customer].
class LoadCustomerPaymentsUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [LoadCustomerPaymentsUseCase] instance.
  const LoadCustomerPaymentsUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Lists the payments of a customer using the provided `customerId`.
  ///
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> call({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool recurring = false,
  }) =>
      _repository.list(
        customerId: customerId,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
        recurring: recurring,
      );
}
