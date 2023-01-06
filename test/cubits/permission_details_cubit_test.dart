import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadPermissionUseCase extends Mock implements LoadPermissionsUseCase {
}

late MockLoadPermissionUseCase _loadPermissionUseCase;
late MockLoadPermissionUseCase _failLoadPermissionUseCase;
late List<PermissionObject> _permissions;

PermissionDetailsCubit create({
  MockLoadPermissionUseCase? useCase,
}) =>
    PermissionDetailsCubit(
      loadPermissionsUseCase: useCase ?? _loadPermissionUseCase,
    );

void main() {
  setUp(() {
    _loadPermissionUseCase = MockLoadPermissionUseCase();
    _failLoadPermissionUseCase = MockLoadPermissionUseCase();

    _permissions = List.generate(5, (index) => PermissionObject(id: index));

    when(
      () => _loadPermissionUseCase(),
    ).thenAnswer(
      (_) async => _permissions,
    );

    when(
      () => _failLoadPermissionUseCase(),
    ).thenThrow(
      Exception('Error'),
    );
  });

  blocTest<PermissionDetailsCubit, PermissionDetailsState>(
    'Should start with empty state',
    build: create,
    verify: (c) => expect(
      c.state,
      PermissionDetailsState(),
    ),
  );

  blocTest<PermissionDetailsCubit, PermissionDetailsState>(
    'Should load permissions correctly',
    build: create,
    act: (c) => c.load(),
    expect: () => [
      PermissionDetailsState(
        busy: true,
        error: false,
        permissionsList: [],
      ),
      PermissionDetailsState(
        busy: false,
        error: false,
        permissionsList: _permissions,
      ),
    ],
  );

  blocTest<PermissionDetailsCubit, PermissionDetailsState>(
    'Should handle exceptions gracefully',
    build: () => create(
      useCase: _failLoadPermissionUseCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      PermissionDetailsState(
        busy: true,
        error: false,
        permissionsList: [],
      ),
      PermissionDetailsState(
        busy: false,
        error: true,
        permissionsList: [],
      ),
    ],
  );
}
