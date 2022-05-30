import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles logic related to the cashback history.
class CashbackHistoryCubit extends Cubit<CashbackHistoryState> {
  final LoadCashbackHistory _loadCashbackHistory;

  /// Creates [CashbackHistoryCubit].
  CashbackHistoryCubit({
    required CashbackHistoryRepositoryInterface repository,
  })  : _loadCashbackHistory = LoadCashbackHistory(
          repository: repository,
        ),
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
      final cashbackHistory = await _loadCashbackHistory(
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
