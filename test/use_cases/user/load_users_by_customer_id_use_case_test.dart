import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepositoryInterface extends Mock
    implements UserRepositoryInterface {}

late MockUserRepositoryInterface _mock;
late LoadUsersByCustomerIdUseCase _useCase;
late List<User> _mockResult;

void main() {
  setUp(() {
    _mock = MockUserRepositoryInterface();
    _useCase = LoadUsersByCustomerIdUseCase(repository: _mock);

    _mockResult = [
      User(id: 'someUser'),
    ];

    when(
      () => _mock.getUsers(
        customerID: any(named: 'customerID'),
      ),
    ).thenAnswer(
      (_) async => _mockResult,
    );
  });

  test('Should return user', () async {
    final result = await _useCase(
      customerID: 'someCustomerId',
    );

    expect(result, _mockResult);

    verify(
      () => _mock.getUsers(
        customerID: any(named: 'customerID'),
      ),
    ).called(1);
  });
}
