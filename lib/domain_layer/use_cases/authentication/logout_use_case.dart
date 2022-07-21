import '../../abstract_repositories.dart';

/// Use case that logs out a user with the provided value,
/// deviceId.
class LogoutUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [LogoutUseCase] instance.
  LogoutUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Logs out the user belonging to `deviceId`.
  Future<void> call({
    int? deviceId,
  }) =>
      _repository.logout(
        deviceId: deviceId,
      );
}
