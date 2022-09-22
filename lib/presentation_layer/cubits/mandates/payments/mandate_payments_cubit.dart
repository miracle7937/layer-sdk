import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../utils.dart';
import 'mandate_payments_state.dart';

/// Cubit that handle [MandatePayment] data
class MandatePaymentsCubit extends Cubit<MandatePaymentsState> {
  final LoadMandatePaymentUseCase _loadPaymentsUC;

  /// If provided, only the payments related to this mandate id will be
  /// fetched
  final int? mandateId;

  /// Creates a new [MandatePaymentsCubit] instance
  MandatePaymentsCubit({
    required LoadMandatePaymentUseCase loadMandatePaymentsUseCase,
    this.mandateId,
    int limit = 25,
  })  : _loadPaymentsUC = loadMandatePaymentsUseCase,
        super(
          MandatePaymentsState(
            pagination: Pagination(limit: limit),
          ),
        );

  /// TODO: Change the [sortBy] parameter to be an enum.
  ///
  /// Loads [MandatePayments] data
  ///
  /// If the [desc] parameter is `true`, the values will be returned
  /// in a descending order.
  Future<void> load({
    String? sortBy,
    bool desc = false,
    bool loadMore = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        busyAction: loadMore
            ? MandatePaymentsBusyAction.loadingMore
            : MandatePaymentsBusyAction.loading,
        errorStatus: MandatePaymentsErrorStatus.none,
      ),
    );

    try {
      final pagination = state.pagination.paginate(loadMore: loadMore);

      // TODO: send mandate id
      final foundPayments = await _loadPaymentsUC(
        limit: pagination.limit,
        offset: pagination.offset,
        descending: desc,
        sortBy: sortBy,
        mandateId: mandateId,
      );

      final payments = pagination.firstPage
          ? foundPayments
          : [
              ...state.payments,
              ...foundPayments,
            ];

      emit(
        state.copyWith(
          busy: false,
          payments: payments,
          pagination: pagination.refreshCanLoadMore(
            loadedCount: foundPayments.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? MandatePaymentsErrorStatus.network
              : MandatePaymentsErrorStatus.generic,
          busy: false,
        ),
      );
    }
  }
}
