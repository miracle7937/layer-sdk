import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/branch_activation.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

late MockUserRepository _repository;
late SetAccessPinForUserUseCase _useCase;
late MockUser _user;

final _token = 'Bearer test';
final _pin = '123123';

void main() {
  setUp(() {
    _repository = MockUserRepository();
    _useCase = SetAccessPinForUserUseCase(repository: _repository);

    _user = MockUser();

    when(
      () => _repository.setAccessPin(
        token: any(named: 'token'),
        pin: any(named: 'pin'),
      ),
    ).thenAnswer((_) async => _user);
  });

  test('Sets the user access pin and returns it', () async {
    final result = await _useCase(token: _token, pin: _pin);

    expect(result, _user);

    verify(
      () => _repository.setAccessPin(token: _token, pin: _pin),
    ).called(1);
  });
}
