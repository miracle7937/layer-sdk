import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for access pin validation.
///
/// It checks whether the provided pin violates the maximum repetitive
/// characters rule and maximum sequential digits rule based on the global
/// settings.
class AccessPinValidationCubit extends Cubit<AccessPinValidationState> {
  final ValidateAccessPinRepetitiveCharactersUseCase
      _validateRepetitiveCharacters;
  final ValidateAccessPinSequentialDigitsUseCase _validateSequentialDigits;
  final LoadGlobalSettingsUseCase _loadGlobalSettings;

  /// Creates new [AccessPinValidationState].
  AccessPinValidationCubit({
    required ValidateAccessPinRepetitiveCharactersUseCase
        validateRepetitiveCharactersUseCase,
    required ValidateAccessPinSequentialDigitsUseCase
        validateSequentialDigitsUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
  })  : _validateRepetitiveCharacters = validateRepetitiveCharactersUseCase,
        _validateSequentialDigits = validateSequentialDigitsUseCase,
        _loadGlobalSettings = loadGlobalSettingsUseCase,
        super(AccessPinValidationState());

  /// Fetches the values for the global settings that control the pin validation
  /// rules.
  Future<void> load() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          AccessPinValidationAction.loadSettings,
        ),
      ),
    );

    try {
      final settings = await _loadGlobalSettings(
        module: 'access_pin',
        codes: [
          'maximum_repetitive_characters',
          'maximum_sequential_digits',
        ],
      );
      emit(
        state.copyWith(
          actions: state.removeAction(
            AccessPinValidationAction.loadSettings,
          ),
          maximumRepetitiveCharacters: settings
              .firstWhere((e) => e.code == 'maximum_repetitive_characters')
              .value,
          maximumSequentialDigits: settings
              .firstWhere((e) => e.code == 'maximum_sequential_digits')
              .value,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AccessPinValidationAction.loadSettings,
          ),
          errors: state.addErrorFromException(
            action: AccessPinValidationAction.loadSettings,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Performs the validation on the provided pin.
  ///
  /// Depends on the validation rule values stored in the state. If their values
  /// are `null` then the validation will be considered successful. Be sure to
  /// load their values first using the [load] method.
  void validate({
    required String pin,
  }) {
    emit(
      state.copyWith(
        errors: state.clearValidationErrors(),
      ),
    );

    final maximumRepetitiveCharactersValid =
        state.maximumRepetitiveCharacters == null ||
            _validateRepetitiveCharacters(
              maximumRepetitiveCharacters: state.maximumRepetitiveCharacters!,
              pin: pin,
            );
    final maximumSequentialDigitsValid =
        state.maximumSequentialDigits == null ||
            _validateSequentialDigits(
              maximumSequentialDigits: state.maximumSequentialDigits!,
              pin: pin,
            );
    emit(
      state.copyWith(
        valid: maximumSequentialDigitsValid && maximumRepetitiveCharactersValid,
        errors: state.addValidationErrors(validationErrors: {
          if (!maximumRepetitiveCharactersValid)
            CubitValidationError(
              validationErrorCode:
                  AccessPinValidationError.maximumRepetitiveCharacters,
            ),
          if (!maximumSequentialDigitsValid)
            CubitValidationError(
              validationErrorCode:
                  AccessPinValidationError.maximumSequentialDigits,
            ),
        }),
      ),
    );
  }

  /// Clears validation errors.
  void clearValidationErrors() {
    emit(
      state.copyWith(
        errors: state.clearValidationErrors(),
      ),
    );
  }
}
