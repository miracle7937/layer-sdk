import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockUserRepository _repository;
  late LoadUserByCustomerIdUseCase _loadUserByCustomerIdUseCase;

  final _mockedUser = User(id: 'id');

  setUp(() {
    _repository = MockUserRepository();
    _loadUserByCustomerIdUseCase = LoadUserByCustomerIdUseCase(
      repository: _repository,
    );

    when(() => _loadUserByCustomerIdUseCase()).thenAnswer(
      (_) async => _mockedUser,
    );
  });

  test('Should return an User', () async {
    final response = await _loadUserByCustomerIdUseCase();

    expect(response, _mockedUser);

    verify(() => _repository.getUser()).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
