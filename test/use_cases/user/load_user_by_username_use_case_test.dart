import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepositoryInterface extends Mock
    implements UserRepositoryInterface {}

late MockUserRepositoryInterface _mock;
late LoadUserByUsernameUseCase _useCase;
late User _mockUser;

void main() {
  setUp(() {
    _mock = MockUserRepositoryInterface();
    _useCase = LoadUserByUsernameUseCase(repository: _mock);

    _mockUser = User(id: 'someUser');

    when(
      () => _mock.getUser(
        username: any(named: 'username'),
      ),
    ).thenAnswer(
      (_) async => _mockUser,
    );
  });

  test('Should return user', () async {
    final result = await _useCase('someusername');

    expect(result, _mockUser);

    verify(
      () => _mock.getUser(
        username: any(named: 'username'),
      ),
    ).called(1);
  });
}
