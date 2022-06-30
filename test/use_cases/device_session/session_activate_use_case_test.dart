import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockDeviceSessionRepository extends Mock
    implements DeviceSessionRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockDeviceSessionRepository _repository;
  late ActivateDeviceSessionUseCase _deviceSessionActivateUseCase;

  late Completer _completer;

  setUp(() {
    _repository = MockDeviceSessionRepository();
    _deviceSessionActivateUseCase = ActivateDeviceSessionUseCase(
      repository: _repository,
    );
    _completer = Completer<void>();

    when(() => _deviceSessionActivateUseCase(
          deviceId: any(
            named: 'deviceId',
          ),
        )).thenAnswer((_) async => _completer.complete());
  });

  test('Should call activate session properly', () async {
    await _deviceSessionActivateUseCase(
      deviceId: '1',
    );

    verify(
      () => _repository.activateSession(
        deviceId: any(
          named: 'deviceId',
        ),
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
