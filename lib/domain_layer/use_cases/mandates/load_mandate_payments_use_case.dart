import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading Mandate Payments
class LoadMandatePaymentUseCase {
  final MandatePaymentRepositoryInterface _repository;

  /// Creates a new [LoadMandatePaymentUseCase] instance
  const LoadMandatePaymentUseCase({
    required MandatePaymentRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads all [MandatePayment].
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  ///
  /// Use the `descending` parameter to specify if the sort is
  /// descending or ascending.
  Future<List<MandatePayment>> call({
    int? limit,
    int? offset,
    String? sortBy,
    int? mandateId,
    bool descending = false,
  }) =>
      _repository.fetchMandatePayments(
        limit: limit,
        offset: offset,
        sortBy: sortBy,
        desc: descending,
        mandateId: mandateId,
      );
}
