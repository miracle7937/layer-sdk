import '../../features/user.dart';
import '../cubits.dart';
import '../widgets.dart';

/// Creator responsible for creating [SetPinScreenCubit].
class SetPinScreenCreator extends CubitCreator {
  final UserRepositoryInterface _userRepository;

  /// Creates a new [SetPinScreenCreator] instance.
  SetPinScreenCreator({
    required UserRepositoryInterface userRepository,
  }) : _userRepository = userRepository;

  /// Creates and returns an instance of the [SetPinScreenCubit].
  SetPinScreenCubit create({
    required String userToken,
  }) =>
      SetPinScreenCubit(
        userToken: userToken,
        setAccessPinForUserUseCase: SetAccessPinForUserUseCase(
          repository: _userRepository,
        ),
      );
}
