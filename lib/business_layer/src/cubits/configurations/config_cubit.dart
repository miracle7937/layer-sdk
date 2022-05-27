import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';
import 'config_state.dart';

/// Cubit responsible for configurations.
class ConfigCubit extends Cubit<ConfigState> {
  final ConfigRepository _repository;

  /// Creates a new instance of [ConfigCubit]
  ConfigCubit({
    required ConfigRepository repository,
  })  : _repository = repository,
        super(ConfigState());

  /// Loads configurations.
  Future<void> load({
    bool forceRefresh = true,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: ConfigStateErrors.none,
      ),
    );

    try {
      final config = await _repository.load(
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          config: config,
          busy: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: ConfigStateErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
