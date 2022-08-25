import '../../abstract_repositories.dart';
import '../../models.dart';

/// The use case that terminates the device session
class TerminateDeviceSessionUseCase {
  final DeviceSessionRepositoryInterface _repository;

  /// Creates a new [TerminateDeviceSessionUseCase] use case.
  TerminateDeviceSessionUseCase({
    required DeviceSessionRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to terminate id belonging device session
  /// The [customerType] value is used for sending the customer type that
  /// belong to device session.
  Future<void> call({
    required String deviceId,
    required CustomerType customerType,
  }) =>
      _repository.terminateSession(
        deviceId: deviceId,
        customerType: customerType,
      );
}
