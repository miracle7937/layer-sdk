import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepositoryInterface {}

class MockMessageResponse extends Mock implements MessageResponse {}

void main() {
  EquatableConfig.stringify = true;
  late MockAuthenticationRepository _repository;
  late ChangePasswordUseCase _useCase;
  late MockMessageResponse _messageResponse;
  final _user = User(
    id: 'User Test',
  );
  setUp(() {
    _messageResponse = MockMessageResponse();
    _repository = MockAuthenticationRepository();
    _useCase = ChangePasswordUseCase(repository: _repository);

    when(
      () => _repository.changePassword(
        userId: any(named: 'userId'),
        user: any(named: 'user'),
        username: any(named: 'username'),
        newPassword: any(named: 'newPassword'),
        oldPassword: any(named: 'oldPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).thenAnswer((_) async => _messageResponse);
  });

  test('Verifies new password with confirm password and changes it', () async {
    final result = await _useCase(
        user: _user,
        oldPassword: "123456",
        newPassword: "123123",
        confirmPassword: "123123");

    expect(result, _messageResponse);

    verify(
      () => _repository.changePassword(
          user: _user,
          oldPassword: "123456",
          newPassword: "123123",
          confirmPassword: "123123"),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
