import '../../abstract_repositories.dart';

/// The use case that activates the device session
class DeviceSessionActivateUseCase {
  final DeviceSessionRepositoryInterface _repository;

  /// Creates a new [DeviceSessionActivateUseCase] use case.
  DeviceSessionActivateUseCase({
    required DeviceSessionRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to send id on campaign action
  Future<void> call({
    required int deviceId,
  }) =>
      _repository.activateSession(
        deviceId: deviceId,
      );
}