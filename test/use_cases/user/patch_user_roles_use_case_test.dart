import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockUserRepository _repository;
  late PatchUserRolesUseCase _patchUserRolesUseCase;

  setUp(() {
    _repository = MockUserRepository();
    _patchUserRolesUseCase = PatchUserRolesUseCase(repository: _repository);

    when(
      () => _patchUserRolesUseCase(
        userId: any(named: 'userId'),
        roles: any(named: 'roles'),
      ),
    ).thenAnswer(
      (_) async => true,
    );
  });

  test('Should return a true value', () async {
    final response = await _patchUserRolesUseCase(
      userId: 'userId',
      roles: ['role'],
    );

    expect(response, true);

    verify(
      () => _repository.patchUserRoles(
        userId: any(named: 'userId'),
        roles: any(named: 'roles'),
      ),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
