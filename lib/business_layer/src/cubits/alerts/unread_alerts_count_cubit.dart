import 'dart:math';

import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';

import '../../cubits.dart';

///A cubit that holds the unread alerts count
class UnreadAlertsCountCubit extends Cubit<UnreadAlertsCountState> {
  final AlertRepository _repository;

  ///Crates a new [UnreadAlertsCountCubit] providing an [AlertRepository]
  UnreadAlertsCountCubit({
    required AlertRepository repository,
  })  : _repository = repository,
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
      final count = await _repository.getUnreadAlertsCount(
        forceRefresh: true,
      );

      notify(count);
    } on Exception catch (e) {
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
