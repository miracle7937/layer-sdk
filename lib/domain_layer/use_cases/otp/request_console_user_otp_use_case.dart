import '../../abstract_repositories.dart';

/// Use case that Requests a new OTP id from the server for console users.
class RequestConsoleUserOTPUseCase {
  final SecondFactorRepositoryInterface _repository;

  /// Creates a new [RequestConsoleUserOTPUseCase] instance.
  RequestConsoleUserOTPUseCase({
    required SecondFactorRepositoryInterface repository,
  }) : _repository = repository;

  /// Requests a new OTP for a console user with the provided `deviceId`.
  Future<int?> call({
    required int deviceId,
  }) =>
      _repository.verifyConsoleUserDeviceLogin(
        deviceId: deviceId,
      );
}
