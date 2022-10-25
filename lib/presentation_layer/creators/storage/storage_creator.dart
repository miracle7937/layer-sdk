import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../widgets.dart';

/// A creator responsible for creating the [StorageCubit].
class StorageCreator implements CubitCreator {
  final LoadLoggedInUsersUseCase _loadLoggedInUsersUseCase;
  final LoadLastLoggedUserUseCase _loadLastLoggedUserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  final RemoveUserUseCase _removeUserUseCase;
  final LoadAuthenticationSettingsUseCase _loadAuthenticationSettingsUseCase;
  final SaveAuthenticationSettingUseCase _saveAuthenticationSettingUseCase;
  final LoadOcraSecretKeyUseCase _loadOcraSecretKeyUseCase;
  final SaveOcraSecretKeyUseCase _saveOcraSecretKeyUseCase;
  final SetBrightnessUseCase _setBrightnessUseCase;
  final LoadBrightnessUseCase _loadBrightnessUseCase;
  final ToggleBiometricsUseCase _toggleBiometricsUseCase;
  final LoadUserDetailsFromTokenUseCase _loadUserDetailsFromTokenUseCase;

  /// Creates [StorageCreator].
  StorageCreator({
    required LoadLoggedInUsersUseCase loadLoggedInUsersUseCase,
    required LoadLastLoggedUserUseCase loadLastLoggedUserUseCase,
    required SaveUserUseCase saveUserUseCase,
    required RemoveUserUseCase removeUserUseCase,
    required LoadAuthenticationSettingsUseCase
        loadAuthenticationSettingsUseCase,
    required SaveAuthenticationSettingUseCase saveAuthenticationSettingUseCase,
    required LoadOcraSecretKeyUseCase loadOcraSecretKeyUseCase,
    required SaveOcraSecretKeyUseCase saveOcraSecretKeyUseCase,
    required SetBrightnessUseCase setBrightnessUseCase,
    required LoadBrightnessUseCase loadBrightnessUseCase,
    required ToggleBiometricsUseCase toggleBiometricsUseCase,
    required LoadUserDetailsFromTokenUseCase loadUserDetailsFromTokenUseCase,
  })  : _loadLoggedInUsersUseCase = loadLoggedInUsersUseCase,
        _loadLastLoggedUserUseCase = loadLastLoggedUserUseCase,
        _saveUserUseCase = saveUserUseCase,
        _removeUserUseCase = removeUserUseCase,
        _loadAuthenticationSettingsUseCase = loadAuthenticationSettingsUseCase,
        _saveAuthenticationSettingUseCase = saveAuthenticationSettingUseCase,
        _loadOcraSecretKeyUseCase = loadOcraSecretKeyUseCase,
        _saveOcraSecretKeyUseCase = saveOcraSecretKeyUseCase,
        _setBrightnessUseCase = setBrightnessUseCase,
        _loadBrightnessUseCase = loadBrightnessUseCase,
        _loadUserDetailsFromTokenUseCase = loadUserDetailsFromTokenUseCase,
        _toggleBiometricsUseCase = toggleBiometricsUseCase;

  /// Creates the [StorageCubit].
  StorageCubit create() => StorageCubit(
        loadLoggedInUsersUseCase: _loadLoggedInUsersUseCase,
        lastLoggedUserUseCase: _loadLastLoggedUserUseCase,
        saveUserUseCase: _saveUserUseCase,
        removeUserUseCase: _removeUserUseCase,
        loadAuthenticationSettingsUseCase: _loadAuthenticationSettingsUseCase,
        saveAuthenticationSettingUseCase: _saveAuthenticationSettingUseCase,
        loadOcraSecretKeyUseCase: _loadOcraSecretKeyUseCase,
        saveOcraSecretKeyUseCase: _saveOcraSecretKeyUseCase,
        setBrightnessUseCase: _setBrightnessUseCase,
        loadBrightnessUseCase: _loadBrightnessUseCase,
        toggleBiometricsUseCase: _toggleBiometricsUseCase,
        loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      );
}
