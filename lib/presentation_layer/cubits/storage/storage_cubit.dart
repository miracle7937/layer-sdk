import 'package:bloc/bloc.dart';

import '../../../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles loading and saving data in storage.
class StorageCubit extends Cubit<StorageState> {
  /// The storage solution to be used for sensitive data.
  final LoadLastLoggedUserUseCase _lastLoggedUserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  final RemoveUserUseCase _removeUserUseCase;
  final LoadAuthenticationSettingsUseCase _loadAuthenticationSettingUseCase;
  final SaveAuthenticationSettingUseCase _saveAuthenticationSettingUseCase;
  final LoadOcraSecretKeyUseCase _loadOcraSecretKeyUseCase;
  final SaveOcraSecretKeyUseCase _saveOcraSecretKeyUseCase;
  final SetBrightnessUseCase _setBrightnessUseCase;
  final LoadBrightnessUseCase _loadBrightnessUseCase;
  final ToggleBiometricsUseCase _toggleBiometricsUseCase;

  /// Creates [StorageCubit].
  StorageCubit({
    required LoadLastLoggedUserUseCase lastLoggedUserUseCase,
    required SaveUserUseCase saveUserUseCase,
    required RemoveUserUseCase removeUserUseCase,
    required LoadAuthenticationSettingsUseCase loadAuthenticationSettingUseCase,
    required SaveAuthenticationSettingUseCase saveAuthenticationSettingUseCase,
    required LoadOcraSecretKeyUseCase loadOcraSecretKeyUseCase,
    required SaveOcraSecretKeyUseCase saveOcraSecretKeyUseCase,
    required SetBrightnessUseCase setBrightnessUseCase,
    required LoadBrightnessUseCase loadBrightnessUseCase,
    required ToggleBiometricsUseCase toggleBiometricsUseCase,
  })  : _lastLoggedUserUseCase = lastLoggedUserUseCase,
        _saveUserUseCase = saveUserUseCase,
        _removeUserUseCase = removeUserUseCase,
        _loadAuthenticationSettingUseCase = loadAuthenticationSettingUseCase,
        _saveAuthenticationSettingUseCase = saveAuthenticationSettingUseCase,
        _loadOcraSecretKeyUseCase = loadOcraSecretKeyUseCase,
        _saveOcraSecretKeyUseCase = saveOcraSecretKeyUseCase,
        _setBrightnessUseCase = setBrightnessUseCase,
        _loadBrightnessUseCase = loadBrightnessUseCase,
        _toggleBiometricsUseCase = toggleBiometricsUseCase,
        super(StorageState());

  /// Loads the last logged user from storage.
  ///
  /// Emits a busy state while loading.
  Future<void> loadLastLoggedUser() async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );
    try {
      final user = await _lastLoggedUserUseCase();

      emit(
        state.copyWith(
          busy: false,
          currentUser: user,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Saves the provided user in storage and sets him as current user.
  ///
  /// Emits a busy state while saving.
  Future<void> saveUser({required User user}) async {
    emit(state.copyWith(
      busy: true,
    ));
    try {
      await _saveUserUseCase(user: user);

      emit(
        state.copyWith(
          busy: false,
          currentUser: user,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Removes user data from storage for the provided id.
  ///
  /// Emits a busy state while saving.
  Future<void> removeUser(String id) async {
    emit(state.copyWith(busy: true));
    try {
      await _removeUserUseCase(
        id: id,
      );

      emit(state.copyWith(
        busy: false,
        clearCurrentUser: state.currentUser?.id == id,
      ));
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Loads the authentication related settings from the storage.
  /// Emits a busy state at the start, and the loaded settings on completion.
  Future<void> loadAuthenticationSettings() async {
    emit(state.copyWith(busy: true));
    try {
      final authenticationSettings = await _loadAuthenticationSettingUseCase();

      emit(
        state.copyWith(
          authenticationSettings: authenticationSettings,
          busy: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Saves the current authentication settings to the storage.
  /// The default username is taken from the user currently logged in.
  /// Emits a busy state at the start, and one with the saved settings
  /// on completion.
  Future<void> saveAuthenticationSettings({
    String? domain,
    bool? useBiometrics,
  }) async {
    emit(state.copyWith(busy: true));
    try {
      final defaultUsername =
          useBiometrics != null ? state.currentUser?.username : null;

      final authenticationSettings = await _saveAuthenticationSettingUseCase(
          defaultUsername: defaultUsername,
          domain: domain,
          useBiometrics: useBiometrics);

      emit(
        state.copyWith(
          authenticationSettings: state.authenticationSettings.copyWith(
            domain: authenticationSettings.domain,
            defaultUsername: authenticationSettings.defaultUsername,
            useBiometrics: authenticationSettings.useBiometrics,
          ),
          busy: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Sets the biometric usage to the provided value
  void toggleBiometric({
    required bool isBiometricsActive,
  }) async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      await _toggleBiometricsUseCase(isBiometricsActive: isBiometricsActive);

      emit(
        state.copyWith(
          busy: false,
          authenticationSettings: state.authenticationSettings.copyWith(
            useBiometrics: isBiometricsActive,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Loads the application settings from the storage.
  /// Emits a busy state at the start, and the loaded settings on completion.
  Future<void> loadApplicationSettings() async {
    emit(
      state.copyWith(busy: true),
    );

    try {
      final brightnessIndex = await _loadBrightnessUseCase();

      emit(
        state.copyWith(
          busy: false,
          applicationSettings: state.applicationSettings.copyWith(
            brightness: SettingThemeBrightness.values[brightnessIndex ?? 0],
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Sets the theme brightness
  void setThemeBrightness({
    required SettingThemeBrightness themeBrightness,
  }) async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final result = await _setBrightnessUseCase(
          themeBrightnessIndex: themeBrightness.index);

      emit(
        state.copyWith(
          busy: false,
          applicationSettings: state.applicationSettings.copyWith(
            brightness: result ? themeBrightness : null,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Saves the secret key for OCRA mutual authentication flow.
  Future<void> saveOcraSecretKey(String key) async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final result = await _saveOcraSecretKeyUseCase(value: key);

      emit(
        state.copyWith(
          busy: false,
          ocraSecretKey: result ? key : null,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Loads the secret key for OCRA mutual authentication flow.
  Future<void> loadOcraSecretKey() async {
    emit(
      state.copyWith(busy: true),
    );

    try {
      final key = await _loadOcraSecretKeyUseCase();

      emit(
        state.copyWith(
          busy: false,
          ocraSecretKey: key,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }
}
