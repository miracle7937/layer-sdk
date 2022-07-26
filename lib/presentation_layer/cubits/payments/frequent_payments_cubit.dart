import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps a list of frequently made payments.
class FrequentPaymentsCubit extends Cubit<FrequentPaymentsState> {
  final LoadFrequentPaymentsUseCase _loadFrequentPaymentsUseCase;

  /// Creates a new cubit using the supplied [LoadFrequentPaymentsUseCase]
  FrequentPaymentsCubit({
    required LoadFrequentPaymentsUseCase loadFrequentPaymentsUseCase,
    int limit = 50,
  })  : _loadFrequentPaymentsUseCase = loadFrequentPaymentsUseCase,
        super(
          FrequentPaymentsState(
            limit: limit,
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
      ),
    );

    final offset = loadMore ? state.offset + state.limit : 0;

    try {
      final payments = await _loadFrequentPaymentsUseCase(
        offset: offset,
        limit: state.limit,
      );

      final list = offset > 0
          ? [...state.payments.take(offset).toList(), ...payments]
          : payments;

      emit(
        state.copyWith(
          payments: list,
          busy: false,
          offset: offset,
          canLoadMore: state.payments.length != list.length,
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
