import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models/customer/customer.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockUserRepository _repository;
  late RequestUnlockUseCase _requestUnlockUseCase;
  late Completer _completer;

  setUp(() {
    _repository = MockUserRepository();
    _requestUnlockUseCase = RequestUnlockUseCase(
      repository: _repository,
    );

    _completer = Completer<void>();

    when(
      () => _requestUnlockUseCase(
        userId: any(named: 'userId'),
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => _completer.complete());
  });

  test('Should call the repository properly', () async {
    await _requestUnlockUseCase(
      userId: '42',
      customerType: CustomerType.personal,
    );

    verify(
      () => _repository.requestUnlock(
        userId: any(named: 'userId'),
        customerType: CustomerType.personal,
      ),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
