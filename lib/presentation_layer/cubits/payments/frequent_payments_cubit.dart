import 'package:bloc/bloc.dart';

import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../utils.dart';

/// A cubit that keeps a list of frequently made payments.
class FrequentPaymentsCubit extends Cubit<FrequentPaymentsState> {
  final LoadFrequentPaymentsUseCase _loadFrequentPaymentsUseCase;

  /// Creates a new cubit using the supplied [LoadFrequentPaymentsUseCase]
  FrequentPaymentsCubit({
    required LoadFrequentPaymentsUseCase loadFrequentPaymentsUseCase,
    int limit = 25,
  })  : _loadFrequentPaymentsUseCase = loadFrequentPaymentsUseCase,
        super(
          FrequentPaymentsState(
            pagination: Pagination(
              limit: 25,
            ),
          ),
        );

  /// Loads the customer's list of frequent payments
  Future<void> load({
    bool loadMore = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: FrequentPaymentsErrorStatus.none,
        busyAction: loadMore
            ? FrequentPaymentsBusyAction.loadingMore
            : FrequentPaymentsBusyAction.loading,
      ),
    );

    try {
      final pagination = state.pagination.paginate(loadMore: loadMore);

      final payments = await _loadFrequentPaymentsUseCase(
        limit: pagination.limit,
        offset: pagination.offset,
      );

      final list = pagination.firstPage
          ? payments
          : [
              ...state.payments,
              ...payments,
            ];

      emit(
        state.copyWith(
          busy: false,
          payments: list,
          pagination: pagination.refreshCanLoadMore(
            loadedCount: payments.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? FrequentPaymentsErrorStatus.network
              : FrequentPaymentsErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
