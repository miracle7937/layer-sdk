import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockAuthenticationRepository _repository;
  late LogoutUseCase _useCase;

  late Completer _completer;

  setUp(() {
    _repository = MockAuthenticationRepository();
    _useCase = LogoutUseCase(
      repository: _repository,
    );
    _completer = Completer<void>();

    when(() => _useCase(
          deviceId: any(
            named: 'deviceId',
          ),
        )).thenAnswer((_) async => _completer.complete());
  });

  test('Should logout user device properly', () async {
    await _useCase(
      deviceId: 1,
    );

    verify(
      () => _repository.logout(
        deviceId: any(
          named: 'deviceId',
        ),
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
