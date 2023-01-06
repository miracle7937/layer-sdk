import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockPermissionsRepository extends Mock
    implements PermissionRepositoryInterface {}

late LoadPermissionsUseCase _useCase;
late MockPermissionsRepository _repository;

late List<PermissionObject> _permissions;

void main() {
  setUp(() {
    _repository = MockPermissionsRepository();
    _useCase = LoadPermissionsUseCase(
      repository: _repository,
    );

    _permissions = List.generate(5, (index) => PermissionObject(id: index));

    when(
      () => _repository.listPermissions(),
    ).thenAnswer(
      (_) async => _permissions,
    );
  });

  test('Should return the correct permissions', () async {
    final result = await _useCase();

    expect(result, _permissions);

    verify(() => _repository.listPermissions()).called(1);
  });
}
