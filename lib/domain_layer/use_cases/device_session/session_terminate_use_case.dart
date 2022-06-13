import '../../abstract_repositories.dart';

/// The use case that terminates the device session
class DeviceSessionTerminateUseCase {
  final DeviceSessionRepositoryInterface _repository;

  /// Creates a new [DeviceSessionTerminateUseCase] use case.
  DeviceSessionTerminateUseCase({
    required DeviceSessionRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to terminate id belonging device session
  /// The [status] value is used for getting only the device sessions that
  /// belong to session status.
  Future<void> call({
    required int deviceId,
  }) =>
      _repository.terminateSession(
        deviceId: deviceId,
      );
}
