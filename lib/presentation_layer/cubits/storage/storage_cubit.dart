import 'package:bloc/bloc.dart';

import '../../../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that handles loading and saving data in storage.
class StorageCubit extends Cubit<StorageState> {
  /// The storage solution to be used for sensitive data.
  final LoadLoggedInUsersUseCase _loadLoggedInUsersUseCase;
  final LoadLastLoggedUserUseCase _lastLoggedUserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  final RemoveUserUseCase _removeUserUseCase;
  final LoadAuthenticationSettingsUseCase _loadAuthenticationSettingsUseCase;
  final SaveAuthenticationSettingUseCase _saveAuthenticationSettingUseCase;
  final LoadOcraSecretKeyUseCase _loadOcraSecretKeyUseCase;
  final SaveOcraSecretKeyUseCase _saveOcraSecretKeyUseCase;
  final LoadAccessPinUseCase _loadAccessPinUseCase;
  final SaveAccessPinUseCase _saveAccessPinUseCase;
  final SetBrightnessUseCase _setBrightnessUseCase;
  final LoadBrightnessUseCase _loadBrightnessUseCase;
  final ToggleBiometricsUseCase _toggleBiometricsUseCase;
  final LoadLoyaltyTutorialCompletionUseCase
      _loadLoyaltyTutorialCompletionUseCase;
  final SetLoyaltyTutorialCompletionUseCase
      _setLoyaltyTutorialCompletionUseCase;

  /// Creates [StorageCubit].
  StorageCubit({
    required LoadLoggedInUsersUseCase loadLoggedInUsersUseCase,
    required LoadLastLoggedUserUseCase lastLoggedUserUseCase,
    required SaveUserUseCase saveUserUseCase,
    required RemoveUserUseCase removeUserUseCase,
    required LoadAuthenticationSettingsUseCase
        loadAuthenticationSettingsUseCase,
    required SaveAuthenticationSettingUseCase saveAuthenticationSettingUseCase,
    required LoadOcraSecretKeyUseCase loadOcraSecretKeyUseCase,
    required SaveOcraSecretKeyUseCase saveOcraSecretKeyUseCase,
    required LoadAccessPinUseCase loadAccessPinUseCase,
    required SaveAccessPinUseCase saveAccessPinUseCase,
    required SetBrightnessUseCase setBrightnessUseCase,
    required LoadBrightnessUseCase loadBrightnessUseCase,
    required ToggleBiometricsUseCase toggleBiometricsUseCase,
    required LoadLoyaltyTutorialCompletionUseCase
        loadLoyaltyTutorialCompletionUseCase,
    required SetLoyaltyTutorialCompletionUseCase
        setLoyaltyTutorialCompletionUseCase,
  })  : _loadLoggedInUsersUseCase = loadLoggedInUsersUseCase,
        _lastLoggedUserUseCase = lastLoggedUserUseCase,
        _saveUserUseCase = saveUserUseCase,
        _removeUserUseCase = removeUserUseCase,
        _loadAuthenticationSettingsUseCase = loadAuthenticationSettingsUseCase,
        _saveAuthenticationSettingUseCase = saveAuthenticationSettingUseCase,
        _loadOcraSecretKeyUseCase = loadOcraSecretKeyUseCase,
        _saveOcraSecretKeyUseCase = saveOcraSecretKeyUseCase,
        _loadAccessPinUseCase = loadAccessPinUseCase,
        _saveAccessPinUseCase = saveAccessPinUseCase,
        _setBrightnessUseCase = setBrightnessUseCase,
        _loadBrightnessUseCase = loadBrightnessUseCase,
        _toggleBiometricsUseCase = toggleBiometricsUseCase,
        _loadLoyaltyTutorialCompletionUseCase =
            loadLoyaltyTutorialCompletionUseCase,
        _setLoyaltyTutorialCompletionUseCase =
            setLoyaltyTutorialCompletionUseCase,
        super(StorageState());

  /// Loads all the logged in users.
  Future<void> loadLoggedInUsers() async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    final loggedInUsers = await _loadLoggedInUsersUseCase();

    emit(
      state.copyWith(
        busy: false,
        loggedInUsers: loggedInUsers,
      ),
    );
  }

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
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Loads state of loyalty tutorial completion.
  Future<void> loadLoyaltyTutorialCompletion() async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final loyaltyTutorialCompleted =
          await _loadLoyaltyTutorialCompletionUseCase();

      emit(
        state.copyWith(
          busy: false,
          loyaltyTutorialCompleted: loyaltyTutorialCompleted,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
      final authenticationSettings = await _loadAuthenticationSettingsUseCase();

      emit(
        state.copyWith(
          authenticationSettings: authenticationSettings,
          busy: false,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
      state.copyWith(
        busy: true,
      ),
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
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final key = await _loadOcraSecretKeyUseCase();

      emit(
        state.copyWith(
          busy: false,
          ocraSecretKey: key,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Sets the loyalty tutorial completion with the provided value,
  /// that is true by default.
  void completeLoyaltyTutorial({
    bool completed = true,
  }) async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final success = await _setLoyaltyTutorialCompletionUseCase(
        completed: completed,
      );

      emit(
        state.copyWith(
          busy: false,
          loyaltyTutorialCompleted: success ? completed : null,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Saves the user access for biometrics authentication.
  Future<void> saveAccessPin(String pin) async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final result = await _saveAccessPinUseCase(value: pin);

      emit(
        state.copyWith(
          busy: false,
          accessPin: result ? pin : null,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Loads the secret key for OCRA mutual authentication flow.
  Future<void> loadAccessPin() async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      var pin = await _loadAccessPinUseCase();

      if (pin == null) {
        pin = await _migratePinFromUser();
      }

      emit(
        state.copyWith(
          busy: false,
          accessPin: pin,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Saves the access pin separately from the user object and returns it.
  ///
  /// Should be called as part of the data migration to store the access pin
  /// separately for users that used biometrics authentication before with pin
  /// being stored inside the user object.
  // TODO: this should be removed after Akorn users are migrated.
  Future<String?> _migratePinFromUser() async {
    final user = state.currentUser ?? await _lastLoggedUserUseCase();

    if (user?.accessPin?.isNotEmpty ?? false) {
      _saveAccessPinUseCase(value: user!.accessPin!);
    }

    return user?.accessPin;
  }
}
