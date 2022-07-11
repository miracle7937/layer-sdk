import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/providers.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;
  late MockAuthenticationRepository _repository;
  late RecoverPasswordUseCase _useCase;

  final _username = 'User test';
  setUp(() {
    _repository = MockAuthenticationRepository();
    _useCase = RecoverPasswordUseCase(repository: _repository);

    when(
      () => _repository.recoverPassword(
        username: any(named: 'username'),
      ),
    ).thenAnswer((_) async => ForgotPasswordRequestStatus.success);
  });

  test('Recovers users password', () async {
    final result = await _useCase(username: _username);

    expect(result, ForgotPasswordRequestStatus.success);

    verify(
      () => _repository.recoverPassword(username: _username),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
