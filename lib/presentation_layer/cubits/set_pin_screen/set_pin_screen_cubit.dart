import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit for the set pin screen. Handles the states of creating
/// a pin for the passed user token.
class SetPinScreenCubit extends Cubit<SetPinScreenState> {
  /// The user token that we are going to create the pin for.
  final String userToken;

  /// The use case for creating the pin.
  final SetAccessPinForUserUseCase _setAccessPinForUserUseCase;

  /// Creates a new [SetPinScreenCubit].
  SetPinScreenCubit({
    required this.userToken,
    required SetAccessPinForUserUseCase setAccessPinForUserUseCase,
  })  : _setAccessPinForUserUseCase = setAccessPinForUserUseCase,
        super(
          SetPinScreenState(),
        );

  /// Sets the passed access pin for the user token.
  Future<void> setAccesPin({
    required String pin,
  }) async {
    assert(pin.isNotEmpty, 'Pin must not be empty');

    emit(
      state.copyWith(busy: true),
    );

    try {
      final user = await _setAccessPinForUserUseCase(
        token: userToken,
        pin: pin,
      );

      emit(
        state.copyWith(
          busy: false,
          user: user,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? SetPinScreenError.network
              : SetPinScreenError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }
}
