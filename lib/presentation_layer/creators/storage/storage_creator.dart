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
  final SaveAccessPinForBiometricsUseCase _saveAccessPinUseCase;
  final SetBrightnessUseCase _setBrightnessUseCase;
  final LoadBrightnessUseCase _loadBrightnessUseCase;
  final LoadLoyaltyTutorialCompletionUseCase
      _loadLoyaltyTutorialCompletionUseCase;
  final SetLoyaltyTutorialCompletionUseCase
      _setLoyaltyTutorialCompletionUseCase;

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
    required SaveAccessPinForBiometricsUseCase saveAccessPinUseCase,
    required SetBrightnessUseCase setBrightnessUseCase,
    required LoadBrightnessUseCase loadBrightnessUseCase,
    required LoadLoyaltyTutorialCompletionUseCase
        loadLoyaltyTutorialCompletionUseCase,
    required SetLoyaltyTutorialCompletionUseCase
        setLoyaltyTutorialCompletionUseCase,
  })  : _loadLoggedInUsersUseCase = loadLoggedInUsersUseCase,
        _loadLastLoggedUserUseCase = loadLastLoggedUserUseCase,
        _saveUserUseCase = saveUserUseCase,
        _removeUserUseCase = removeUserUseCase,
        _loadAuthenticationSettingsUseCase = loadAuthenticationSettingsUseCase,
        _saveAuthenticationSettingUseCase = saveAuthenticationSettingUseCase,
        _loadOcraSecretKeyUseCase = loadOcraSecretKeyUseCase,
        _saveOcraSecretKeyUseCase = saveOcraSecretKeyUseCase,
        _saveAccessPinUseCase = saveAccessPinUseCase,
        _setBrightnessUseCase = setBrightnessUseCase,
        _loadBrightnessUseCase = loadBrightnessUseCase,
        _loadLoyaltyTutorialCompletionUseCase =
            loadLoyaltyTutorialCompletionUseCase,
        _setLoyaltyTutorialCompletionUseCase =
            setLoyaltyTutorialCompletionUseCase;

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
        saveAccessPinForBiometricsUseCase: _saveAccessPinUseCase,
        setBrightnessUseCase: _setBrightnessUseCase,
        loadBrightnessUseCase: _loadBrightnessUseCase,
        loadLoyaltyTutorialCompletionUseCase:
            _loadLoyaltyTutorialCompletionUseCase,
        setLoyaltyTutorialCompletionUseCase:
            _setLoyaltyTutorialCompletionUseCase,
      );
}
