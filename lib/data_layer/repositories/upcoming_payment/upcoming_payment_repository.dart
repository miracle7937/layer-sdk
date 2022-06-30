import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the upcoming payments data
class UpcomingPaymentRepository implements UpcomingPaymentRepositoryInterface {
  final UpcomingPaymentProvider _provider;

  /// Creates a new repository with the supplied [UpcomingPaymentProvider]
  UpcomingPaymentRepository({
    required UpcomingPaymentProvider provider,
  }) : _provider = provider;

  /// Lists all the upcoming payments
  ///
  /// When indicating the cardId, it will only get the upcoming payments
  /// for that card
  @override
  Future<List<UpcomingPayment>> list({
    String? cardId,
    UpcomingPaymentType? type,
    bool forceRefresh = false,
  }) async {
    final upcomingPaymentDTOs = await _provider.list(
      cardId: cardId,
      type: type?.toUpcomingPaymentTypeDTO(),
      forceRefresh: forceRefresh,
    );

    return upcomingPaymentDTOs
        .map((e) => e.toUpcomingPayment())
        .toList(growable: false);
  }

  /// Lists all the upcoming payments for this customer
  @override
  Future<UpcomingPaymentGroup> listAllUpcomingPayments({
    required String customerID,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  }) async {
    final upcomingPaymentGroupDTO = await _provider.listAllUpcomingPayments(
      customerID: customerID,
      offset: offset,
      limit: limit,
      forceRefresh: forceRefresh,
    );

    return upcomingPaymentGroupDTO.toUpcomingPaymentGroup();
  }
}
