import 'package:bloc/bloc.dart';

import '../../../../../data_layer/interfaces.dart';
import '../../../../../domain_layer/models.dart';
import '../../../_migration/data_layer/src/mappings.dart';
import '../../cubits.dart';
import '../../resources.dart';

/// A cubit that handles loading and saving data in storage.
class StorageCubit extends Cubit<StorageState> {
  /// The storage solution to be used for sensitive data.
  final GenericStorage secureStorage;

  /// The storage solution to be used for user preferences.
  final GenericStorage preferencesStorage;

  /// Creates [StorageCubit].
  StorageCubit({
    required this.secureStorage,
    required this.preferencesStorage,
  }) : super(StorageState());

  /// Loads the last logged user from storage.
  ///
  /// Emits a busy state while loading.
  Future<void> loadLastLoggedUser() async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    User? user;

    

    emit(
      state.copyWith(
        busy: false,
        currentUser: user,
      ),
    );
  }

  /// Saves the provided user in storage and sets him as current user.
  ///
  /// Emits a busy state while saving.
  Future<void> saveUser(User user) async {
    emit(state.copyWith(busy: true));

    var loggedUsers = await secureStorage.getJson(StorageKeys.loggedUsers);

    loggedUsers ??= <String, dynamic>{
      'users': [],
    };

    // TODO: encrypt the user data
    loggedUsers['users']
        .removeWhere((u) => UserJsonMapping.fromJson(u).id == user.id);
    loggedUsers['users'].add(user.toJson());

    await secureStorage.setJson(
      StorageKeys.loggedUsers,
      loggedUsers,
    );

    emit(
      state.copyWith(
        busy: false,
        currentUser: user,
      ),
    );
  }

  /// Removes user data from storage for the provided id.
  ///
  /// Emits a busy state while saving.
  Future<void> removeUser(String id) async {
    emit(state.copyWith(busy: true));

    final savedUsers = await secureStorage.getJson(StorageKeys.loggedUsers);

    if (savedUsers != null && savedUsers['users'] != null) {
      final users = savedUsers['users'];

      final filteredUsers = users
          .where(
            (userJson) => userJson['id'] != id,
          )
          .toList();

      await secureStorage.setJson(
        StorageKeys.loggedUsers,
        <String, dynamic>{
          'users': filteredUsers,
        },
      );
    }

    emit(state.copyWith(
      busy: false,
      clearCurrentUser: state.currentUser?.id == id,
    ));
  }

  /// Loads the authentication related settings from the storage.
  /// Emits a busy state at the start, and the loaded settings on completion.
  Future<void> loadAuthenticationSettings() async {
    emit(state.copyWith(busy: true));

    final domain = await preferencesStorage.getString(
      key: StorageKeys.authDomain,
    );

    final defaultUsername = await preferencesStorage.getString(
      key: StorageKeys.authDefaultUsername,
    );

    final useBiometrics = await preferencesStorage.getBool(
      key: StorageKeys.authUseBiometrics,
    );

    emit(
      state.copyWith(
        authenticationSettings: AuthenticationSettings(
          domain: domain,
          defaultUsername: defaultUsername,
          useBiometrics: useBiometrics ?? false,
        ),
        busy: false,
      ),
    );
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

    final savedDomain = domain != null
        ? await preferencesStorage.setString(
            key: StorageKeys.authDomain,
            value: domain,
          )
        : false;

    final defaultUsername =
        useBiometrics != null ? state.currentUser?.username : null;

    final savedUsername = defaultUsername != null
        ? await preferencesStorage.setString(
            key: StorageKeys.authDefaultUsername,
            value: defaultUsername,
          )
        : false;

    final savedBiometrics = useBiometrics != null
        ? await preferencesStorage.setBool(
            key: StorageKeys.authUseBiometrics,
            value: useBiometrics,
          )
        : false;

    emit(
      state.copyWith(
        authenticationSettings: state.authenticationSettings.copyWith(
          domain: savedDomain ? domain : null,
          defaultUsername: savedUsername ? defaultUsername : null,
          useBiometrics: savedBiometrics ? useBiometrics : null,
        ),
        busy: false,
      ),
    );
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
      await preferencesStorage.setBool(
        key: StorageKeys.authUseBiometrics,
        value: isBiometricsActive,
      );

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
      final brightnessIndex = await preferencesStorage.getInt(
        key: StorageKeys.themeBrightness,
      );

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
      final result = await preferencesStorage.setInt(
        key: StorageKeys.themeBrightness,
        value: themeBrightness.index,
      );

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
      final result = await secureStorage.setString(
        key: StorageKeys.ocraSecretKey,
        value: key,
      );

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
      final key = await secureStorage.getString(
        key: StorageKeys.ocraSecretKey,
      );

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
