import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepositoryInterface {}

late String customerID;

void main() {
  EquatableConfig.stringify = true;

  late MockUserRepository _repository;
  late LoadUsersByCustomerIdUseCase _loadUserByCustomerIdUseCase;

  final _mockedUser = User(id: 'id');
  customerID = 'ayylmao';

  setUp(() {
    _repository = MockUserRepository();
    _loadUserByCustomerIdUseCase = LoadUsersByCustomerIdUseCase(
      repository: _repository,
    );

    when(
      () => _loadUserByCustomerIdUseCase(
        customerID: customerID,
      ),
    ).thenAnswer(
      (_) async => [_mockedUser],
    );
  });

  test('Should return an User', () async {
    final response = await _loadUserByCustomerIdUseCase(customerID: customerID);

    expect(response, [_mockedUser]);

    verify(
      () => _repository.getUsers(customerID: customerID),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
