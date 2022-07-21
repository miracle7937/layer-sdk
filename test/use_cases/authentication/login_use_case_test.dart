import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/features/branch_activation.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepositoryInterface {}

class MockUser extends Mock implements User {}

void main() {
  EquatableConfig.stringify = true;
  late MockAuthenticationRepository _repository;
  late LoginUseCase _useCase;
  late MockUser _user;

  final _username = 'User test';
  final _password = '123123';
  setUp(() {
    _repository = MockAuthenticationRepository();
    _useCase = LoginUseCase(repository: _repository);

    _user = MockUser();

    when(
      () => _repository.login(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => _user);
  });

  test('Login and sets the user', () async {
    final result = await _useCase(username: _username, password: _password);

    expect(result, _user);

    verify(
      () => _repository.login(username: _username, password: _password),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
