import '../../../features/payments.dart';
import '../../abstract_repositories.dart';

/// Use case that loads the list of frequent payments.
class LoadFrequentPaymentsUseCase {
  final FrequentPaymentsRepositoryInterface _repository;

  /// Creates a new [LoadFrequentPaymentsUseCase] instance.
  const LoadFrequentPaymentsUseCase({
    required FrequentPaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Lists the frequent payments of a customer.
  ///
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> call({
    int limit = 50,
    int offset = 0,
  }) =>
      _repository.getFrequentPayments(
        limit: limit,
        offset: offset,
      );
}
