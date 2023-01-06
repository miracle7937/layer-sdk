import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepositoryInterface {
}

late MockProfileRepository _repository;
late GetProfileUseCase _useCase;

late Profile _mock;

void main() {
  setUp(() {
    _repository = MockProfileRepository();
    _useCase = GetProfileUseCase(repository: _repository);

    _mock = Profile(
      idNumber: 'somethinghere',
    );

    when(
      () => _repository.getProfile(customerID: any(named: 'customerID')),
    ).thenAnswer((_) async => _mock);
  });

  test('Should return correct profile', () async {
    final result = await _useCase.call(customerID: 'ayyyyy');

    expect(result, _mock);

    verify(
      () => _repository.getProfile(customerID: any(named: 'customerID')),
    ).called(1);
  });
}
