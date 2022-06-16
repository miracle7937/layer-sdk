import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for configurations.
class ConfigCubit extends Cubit<ConfigState> {
  final LoadConfigUseCase _loadConfigUseCase;

  /// Creates a new instance of [ConfigCubit]
  ConfigCubit({
    required LoadConfigUseCase loadConfigUseCase,
  })  : _loadConfigUseCase = loadConfigUseCase,
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
      final config = await _loadConfigUseCase(
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
