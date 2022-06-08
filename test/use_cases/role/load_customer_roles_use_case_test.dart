import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockRolesRepository extends Mock implements RolesRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockRolesRepository _repository;
  late LoadCustomerRolesUseCase _loadCustomerRolesUseCase;

  final _mockedRoles = List.generate(
    3,
    (index) => Role(),
  );

  setUp(() {
    _repository = MockRolesRepository();
    _loadCustomerRolesUseCase = LoadCustomerRolesUseCase(
      repository: _repository,
    );

    when(() => _loadCustomerRolesUseCase()).thenAnswer(
      (_) async => _mockedRoles,
    );
  });

  test('Use case is an instance of LoadCustomerRolesUseCase', () {
    expect(_loadCustomerRolesUseCase, isInstanceOf<LoadCustomerRolesUseCase>());
  });

  test('LoadCustomerRolesUseCase is not null', () {
    expect(_loadCustomerRolesUseCase, isNotNull);
  });

  test('Should return a list of Roles', () async {
    final response = await _loadCustomerRolesUseCase();

    expect(response, _mockedRoles);

    verify(() => _repository.listCustomerRoles());

    verifyNoMoreInteractions(_repository);
  });
}
