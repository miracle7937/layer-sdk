import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../widgets.dart';

/// Creator responsible for creating [AccessPinValidationCubit].
class AccessPinValidationCreator extends CubitCreator {
  final ValidateAccessPinRepetitiveCharactersUseCase
      _validateAccessPinRepetitiveCharactersUseCase;
  final ValidateAccessPinSequentialDigitsUseCase
      _validateAccessPinSequentialDigitsUseCase;
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

  /// Creates a new [AccessPinValidationCreator] instance.
  AccessPinValidationCreator({
    required ValidateAccessPinRepetitiveCharactersUseCase
        validateAccessPinRepetitiveCharactersUseCase,
    required ValidateAccessPinSequentialDigitsUseCase
        validateAccessPinSequentialDigitsUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
  })  : _validateAccessPinRepetitiveCharactersUseCase =
            validateAccessPinRepetitiveCharactersUseCase,
        _validateAccessPinSequentialDigitsUseCase =
            validateAccessPinSequentialDigitsUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase;

  /// Creates and returns an instance of the [AccessPinValidationCubit].
  AccessPinValidationCubit create() => AccessPinValidationCubit(
        validateRepetitiveCharactersUseCase:
            _validateAccessPinRepetitiveCharactersUseCase,
        validateSequentialDigitsUseCase:
            _validateAccessPinSequentialDigitsUseCase,
        loadGlobalSettingsUseCase: _loadGlobalSettingsUseCase,
      );
}
