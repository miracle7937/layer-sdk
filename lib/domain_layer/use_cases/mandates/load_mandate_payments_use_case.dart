import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading Mandate Payments
class LoadMandatePaymentUseCase {
  final MandatePaymentRepositoryInterface _repository;

  /// Creates a new [LoadMandatePaymentUseCase] instance
  const LoadMandatePaymentUseCase({
    required MandatePaymentRepositoryInterface repository,
  }) : _repository = repository;

  /// Load all [MandatePayment]
  Future<List<MandatePayment>> call({
    int? limit,
    int? offset,
    String? sortBy,
    int? mandateId,

    /// If the sort is descending or not
    bool desc = false,
  }) =>
      _repository.fetchMandatePayments(
        limit: limit,
        offset: offset,
        sortBy: sortBy,
        desc: desc,
        mandateId: mandateId,
      );
}
