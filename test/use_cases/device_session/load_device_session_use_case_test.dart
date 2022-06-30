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
  late LoadDeviceSessionsUseCase _loadDeviceSessionUseCase;

  final _mockedDeviceSession = List.generate(3, (index) {
    return DeviceSession();
  });

  setUp(() {
    _repository = MockDeviceSessionRepository();
    _loadDeviceSessionUseCase = LoadDeviceSessionsUseCase(
      repository: _repository,
    );

    when(() => _loadDeviceSessionUseCase(customerId: any(named: 'customerId')))
        .thenAnswer(
      (_) async => _mockedDeviceSession,
    );
  });

  test('Should return a list of Device Sessions', () async {
    final response = await _loadDeviceSessionUseCase(customerId: '1');

    expect(response, _mockedDeviceSession);

    verify(
      () => _repository.getDeviceSessions(
        customerId: any(
          named: 'customerId',
        ),
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
