import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepositoryInterface {}

class MockVerifyPinResponse extends Mock implements VerifyPinResponse {}

void main() {
  EquatableConfig.stringify = true;
  late MockAuthenticationRepository _repository;
  late VerifyAccessPinUseCase _useCase;
  late MockVerifyPinResponse _verifyPinResponse;
  final _pin = '1';
  setUp(() {
    _verifyPinResponse = MockVerifyPinResponse();
    _repository = MockAuthenticationRepository();
    _useCase = VerifyAccessPinUseCase(repository: _repository);

    when(
      () => _repository.verifyAccessPin(
        pin: any(named: 'pin'),
      ),
    ).thenAnswer((_) async => _verifyPinResponse);
  });

  test('Verifies access pin and returns the response', () async {
    final result = await _useCase(pin: _pin);

    expect(result, _verifyPinResponse);

    verify(
      () => _repository.verifyAccessPin(pin: _pin),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
