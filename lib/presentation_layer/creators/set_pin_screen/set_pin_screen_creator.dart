import '../../../../features/user.dart';
import '../../cubits.dart';
import '../../widgets.dart';

/// Creator responsible for creating [SetPinScreenCubit].
class SetPinScreenCreator extends CubitCreator {
  final SetAccessPinForUserUseCase _setAccessPinForUserUseCase;

  /// Creates a new [SetPinScreenCreator] instance.
  SetPinScreenCreator(
      {required SetAccessPinForUserUseCase setAccessPinForUserUseCase})
      : _setAccessPinForUserUseCase = setAccessPinForUserUseCase;

  /// Creates and returns an instance of the [SetPinScreenCubit].
  SetPinScreenCubit create({
    required String userToken,
  }) =>
      SetPinScreenCubit(
        userToken: userToken,
        setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      );
}
