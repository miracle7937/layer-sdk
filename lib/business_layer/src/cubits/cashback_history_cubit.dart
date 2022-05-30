import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../cubits.dart';

/// A cubit that handles logic related to the cashback history.
class CashbackHistoryCubit extends Cubit<CashbackHistoryState> {
  final CashbackHistoryRepository _repository;

  /// Creates [CashbackHistoryCubit].
  CashbackHistoryCubit({
    required CashbackHistoryRepository repository,
  })  : _repository = repository,
        super(CashbackHistoryState());

  /// Loads the cashback history.
  ///
  /// Emits a busy state while loading.
  Future<void> load({
    DateTime? from,
    DateTime? to,
    bool forceRefresh = false,
  }) async {
    emit(state.copyWith(
      busy: true,
      error: CashbackHistoryStateError.none,
    ));

    try {
      final cashbackHistory = await _repository.getCashbackHistory(
        from: from,
        to: to,
        forceRefresh: forceRefresh,
      );

      emit(state.copyWith(
        busy: false,
        cashbackHistory: cashbackHistory,
      ));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? CashbackHistoryStateError.network
              : CashbackHistoryStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
