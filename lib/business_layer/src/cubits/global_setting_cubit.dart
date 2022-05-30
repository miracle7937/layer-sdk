import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../cubits.dart';

/// A cubit responsible for fetching the global console settings.
// TODO: unit tests
class GlobalSettingCubit extends Cubit<GlobalSettingState> {
  final GlobalSettingRepository _repository;

  /// Creates [GlobalSettingCubit].
  GlobalSettingCubit({
    required GlobalSettingRepository repository,
  })  : _repository = repository,
        super(
          GlobalSettingState(),
        );

  /// Loads the global console settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  // TODO: load only the settings that are missing from the state
  Future<void> load({
    List<String>? codes,
    bool forceRefresh = false,
  }) async {
    emit(state.copyWith(
      busy: true,
      error: GlobalSettingError.none,
    ));

    try {
      final settings = await _repository.list(
        codes: codes,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          busy: false,
          settings: {
            ...state.settings,
            ...settings,
          },
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? GlobalSettingError.network
              : GlobalSettingError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
