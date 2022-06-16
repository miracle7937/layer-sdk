import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for getting a list of upcoming payments.
class GetUpcomingPaymentsUseCase {
  final UpcomingPaymentRepositoryInterface _repository;

  /// Creates a new [GetUpcomingPaymentsUseCase].
  const GetUpcomingPaymentsUseCase({
    required UpcomingPaymentRepositoryInterface repository,
  }) : _repository = repository;

  /// Gets the upcoming payments.
  ///
  /// Use the [cardId] to get only the upcoming payments related to that card.
  /// The [type] parameter is used for filtering purposes.
  Future<List<UpcomingPayment>> call({
    String? cardId,
    UpcomingPaymentType? type,
    bool forceRefresh = false,
  }) =>
      _repository.list(
        cardId: cardId,
        type: type,
        forceRefresh: forceRefresh,
      );
}
