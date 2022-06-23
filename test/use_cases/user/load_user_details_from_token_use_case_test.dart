import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/branch_activation.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

late MockUserRepository _repository;
late LoadUserDetailsFromTokenUseCase _useCase;
late MockUser _user;

final _token = 'Bearer test';

void main() {
  setUp(() {
    _repository = MockUserRepository();
    _useCase = LoadUserDetailsFromTokenUseCase(repository: _repository);

    _user = MockUser();

    when(
      () => _repository.getUserFromToken(
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => _user);
  });

  test('Should return a user', () async {
    final result = await _useCase(token: _token);

    expect(result, _user);

    verify(
      () => _repository.getUserFromToken(token: _token),
    ).called(1);
  });
}
