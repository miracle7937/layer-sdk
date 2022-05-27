import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../utils.dart';
import 'upcoming_payment_state.dart';

/// A cubit that keeps upcoming payments
class UpcomingPaymentCubit extends Cubit<UpcomingPaymentState> {
  final UpcomingPaymentRepository _repository;

  /// Creates a new cubit using the supplied [UpcomingPaymentRepository]
  /// and an optional [customerId].
  UpcomingPaymentCubit({
    required UpcomingPaymentRepository repository,
    String? customerId,
    int limit = 50,
  })  : _repository = repository,
        super(
          UpcomingPaymentState(
            customerId: customerId,
            pagination: Pagination(limit: limit),
          ),
        );

  ///Gets the upcoming payments
  ///
  ///When indicating the cardId it only will return the upcoming payments
  ///for that card
  Future<void> load({
    String? cardId,
    UpcomingPaymentType? type,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    );

    try {
      final upcomingPayments = await _repository.list(
        cardId: cardId,
        type: type,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          upcomingPayments: upcomingPayments,
          total: upcomingPayments.fold(
            0.0,
            (amount, payment) => (amount ?? 0.0) + (payment.amount ?? 0.0),
          ),
          currency: upcomingPayments.isNotEmpty
              ? upcomingPayments.first.currency
              : '',
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? UpcomingPaymentErrorStatus.network
              : UpcomingPaymentErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  ///Gets the upcoming payments for the passed customer
  Future<void> loadForCustomer({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    if (state.customerId == null) {
      throw ArgumentError('Customer id is required');
    }

    emit(
      state.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    );

    final newPage = state.pagination.paginate(loadMore: loadMore);

    try {
      final upcomingPayments = await _repository.listAllUpcomingPayments(
        customerID: state.customerId!,
        offset: newPage.offset,
        limit: newPage.limit,
        forceRefresh: forceRefresh,
      );

      final list = newPage.firstPage
          ? upcomingPayments.allPayments
          : [
              ...state.upcomingPayments.take(newPage.offset).toList(),
              ...upcomingPayments.allPayments
            ];

      emit(
        state.copyWith(
          upcomingPayments: list,
          total: upcomingPayments.total,
          currency: upcomingPayments.prefCurrency,
          busy: false,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: state.upcomingPayments.length,
          ),
          hideValues: upcomingPayments.hideValues,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? UpcomingPaymentErrorStatus.network
              : UpcomingPaymentErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
