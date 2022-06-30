import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/use_cases/setting/load_global_settings_use_case.dart';
import 'global_setting_state.dart';

/// A cubit responsible for fetching the global console settings.
class GlobalSettingCubit extends Cubit<GlobalSettingState> {
  final LoadGlobalSettingsUseCase _getGlobalSettingUseCase;

  /// Creates [GlobalSettingCubit].
  GlobalSettingCubit({
    required LoadGlobalSettingsUseCase getGlobalSettingUseCase,
  })  : _getGlobalSettingUseCase = getGlobalSettingUseCase,
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
      final settings = await _getGlobalSettingUseCase(
        codes: codes,
        currentSettings: state.settings,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          busy: false,
          settings: forceRefresh
              ? settings
              : {
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
