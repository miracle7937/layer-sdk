import '../../abstract_repositories.dart';

/// The use case that deactivates the passed device id.
class DeactivateDeviceUseCase {
  final DeviceSessionRepositoryInterface _repository;

  /// Creates a new [DeactivateDeviceUseCase] use case.
  DeactivateDeviceUseCase({
    required DeviceSessionRepositoryInterface repository,
  }) : _repository = repository;

  /// Deactivates the passed device id.
  Future<void> call({
    required int deviceId,
  }) =>
      _repository.deactivateDevice(
        deviceId: deviceId,
      );
}
