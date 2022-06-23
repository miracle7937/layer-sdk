import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading a list of upcoming payments.
class LoadUpcomingPaymentsUseCase {
  final UpcomingPaymentRepositoryInterface _repository;

  /// Creates a new [LoadUpcomingPaymentsUseCase].
  const LoadUpcomingPaymentsUseCase({
    required UpcomingPaymentRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads the upcoming payments.
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
