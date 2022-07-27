import 'package:bloc/bloc.dart';

import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps a list of frequently made payments.
class FrequentPaymentsCubit extends Cubit<FrequentPaymentsState> {
  final LoadFrequentPaymentsUseCase _loadFrequentPaymentsUseCase;

  /// Creates a new cubit using the supplied [LoadFrequentPaymentsUseCase]
  FrequentPaymentsCubit({
    required LoadFrequentPaymentsUseCase loadFrequentPaymentsUseCase,
    int limit = 5,
  })  : _loadFrequentPaymentsUseCase = loadFrequentPaymentsUseCase,
        super(
          FrequentPaymentsState(),
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

      emit(state.copyWith(
        pagination: pagination,
      ));

      final payments = await _loadFrequentPaymentsUseCase(
        limit: pagination.limit,
        offset: pagination.offset,
      );

      final list =
          pagination.firstPage ? payments : [...state.payments, ...payments];

      emit(
        state.copyWith(
          payments: list,
          busy: false,
          canLoadMore: payments.length != pagination.limit,
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
