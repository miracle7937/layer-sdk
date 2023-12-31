import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

///A cubit that holds the unread alerts count
class UnreadAlertsCountCubit extends Cubit<UnreadAlertsCountState> {
  final LoadUnreadAlertsUseCase _loadUnreadAlertsUseCase;

  /// Crates a new [UnreadAlertsCountCubit] providing
  /// an [LoadUnreadAlertsUseCase]
  UnreadAlertsCountCubit({
    required LoadUnreadAlertsUseCase loadUnreadAlertsUseCase,
  })  : _loadUnreadAlertsUseCase = loadUnreadAlertsUseCase,
        super(UnreadAlertsCountState());

  ///Fetches the unread alerts count
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        error: UnreadAlertsCountError.none,
      ),
    );

    try {
      final count = await _loadUnreadAlertsUseCase(
        forceRefresh: true,
      );

      notify(count);
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? UnreadAlertsCountError.network
              : UnreadAlertsCountError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  ///Notifies the unread alerts count
  void notify(int count) {
    emit(
      state.copyWith(
        busy: false,
        count: count,
      ),
    );
  }

  ///Decreases the unread alerts count
  void decrease() => notify(
        max(0, state.count - 1),
      );

  ///Resets the unread alerts count
  void clear() => notify(0);
}
