import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps upcoming payments
class UpcomingPaymentCubit extends Cubit<UpcomingPaymentState> {
  final LoadUpcomingPaymentsUseCase _loadUpcomingPaymentsUseCase;
  final LoadCustomerUpcomingPaymentsUseCase
      _loadCustomerUpcomingPaymentsUseCase;

  /// Creates a new cubit using the supplied use cases
  /// and an optional [customerId].
  UpcomingPaymentCubit({
    required LoadUpcomingPaymentsUseCase loadUpcomingPaymentsUseCase,
    required LoadCustomerUpcomingPaymentsUseCase
        loadCustomerUpcomingPaymentsUseCase,
    String? customerId,
    int limit = 50,
  })  : _loadUpcomingPaymentsUseCase = loadUpcomingPaymentsUseCase,
        _loadCustomerUpcomingPaymentsUseCase =
            loadCustomerUpcomingPaymentsUseCase,
        super(
          UpcomingPaymentState(
            customerId: customerId,
            pagination: Pagination(limit: limit),
          ),
        );

  /// Loads the upcoming payments
  ///
  /// When indicating the cardId it only will return the upcoming payments
  /// for that card
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
      final upcomingPayments = await _loadUpcomingPaymentsUseCase(
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

  /// Loads the upcoming payments for the passed customer
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
      final upcomingPayments = await _loadCustomerUpcomingPaymentsUseCase(
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
