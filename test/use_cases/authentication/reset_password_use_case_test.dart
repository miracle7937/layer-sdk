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
  late ResetPasswordUseCase _useCase;

  final _username = 'User test';
  setUp(() {
    _repository = MockAuthenticationRepository();
    _useCase = ResetPasswordUseCase(repository: _repository);

    when(
      () => _repository.resetPassword(
        username: any(named: 'username'),
        newPassword: any(named: 'newPassword'),
        oldPassword: any(named: 'oldPassword'),
      ),
    ).thenAnswer((_) async => true);
  });

  test('Resets users password with new password', () async {
    final result = await _useCase(
        username: _username, oldPassword: "123456", newPassword: "123123");

    expect(result, true);

    verify(
      () => _repository.resetPassword(
          username: _username, oldPassword: "123456", newPassword: "123123"),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
