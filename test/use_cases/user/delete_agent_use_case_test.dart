import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepositoryInterface extends Mock
    implements UserRepositoryInterface {}

late MockUserRepositoryInterface _mock;
late DeleteAgentUseCase _useCase;
late User _mockUser;

void main() {
  setUp(() {
    _mock = MockUserRepositoryInterface();
    _useCase = DeleteAgentUseCase(repository: _mock);

    _mockUser = User(id: 'SomeId');

    when(
      () => _mock.requestDeleteAgent(
        user: _mockUser,
      ),
    ).thenAnswer(
      (_) async => true,
    );
  });

  test('Should request agent deletion successfully', () async {
    final result = await _useCase(
      user: _mockUser,
    );

    expect(result, true);

    verify(
      () => _mock.requestDeleteAgent(user: _mockUser),
    ).called(1);
  });
}
