import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases.dart';
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
  })  : _loadPaymentsUC = loadMandatePaymentsUseCase,
        super(MandatePaymentsState());

  /// Loads [MandatePayments] data
  Future<void> load({
    // TODO: this should be an enum
    String? sortBy,

    /// If the sort is descending or not
    bool desc = false,
    bool loadMore = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        busyAction: loadMore
            ? MandatePaymentsBusyAction.loadingMore
            : MandatePaymentsBusyAction.loading,
        errorMessage: '',
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
          errorMessage: '',
          errorStatus: MandatePaymentsErrorStatus.none,
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
