import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockDeviceSessionRepository extends Mock
    implements DeviceSessionRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockDeviceSessionRepository _repository;
  late TerminateDeviceSessionUseCase _deviceSessionTerminateUseCase;

  late Completer _completer;

  setUp(() {
    _repository = MockDeviceSessionRepository();
    _deviceSessionTerminateUseCase = TerminateDeviceSessionUseCase(
      repository: _repository,
    );
    _completer = Completer<void>();

    when(() => _deviceSessionTerminateUseCase(
            deviceId: any(
              named: 'deviceId',
            ),
            customerType: CustomerType.personal))
        .thenAnswer((_) async => _completer.complete());
  });

  test('Should call terminate session properly', () async {
    await _deviceSessionTerminateUseCase(
        deviceId: '1', customerType: CustomerType.personal);

    verify(
      () => _repository.terminateSession(
        deviceId: any(
          named: 'deviceId',
        ),
        customerType: CustomerType.personal,
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
