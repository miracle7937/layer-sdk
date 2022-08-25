import '../../abstract_repositories.dart';

/// The use case that activates the device session
class ActivateDeviceSessionUseCase {
  final DeviceSessionRepositoryInterface _repository;

  /// Creates a new [DeviceSessionActivateUseCase] use case.
  ActivateDeviceSessionUseCase({
    required DeviceSessionRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to send device id when session activate
  Future<void> call({
    required String deviceId,
  }) =>
      _repository.activateSession(
        deviceId: deviceId,
      );
}