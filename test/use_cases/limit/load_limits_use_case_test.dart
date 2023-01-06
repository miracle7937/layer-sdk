import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockLimitsRepositoryInterface extends Mock
    implements LimitsRepositoryInterface {}

late LoadLimitsUseCase _useCase;
late MockLimitsRepositoryInterface _mock;
late Limits _mockLimit;

void main() {
  setUp(() {
    _mock = MockLimitsRepositoryInterface();
    _useCase = LoadLimitsUseCase(
      repository: _mock,
    );

    _mockLimit = Limits(
      originalLimitsNotEmpty: false,
    );

    when(
      () => _useCase(
        customerId: any(named: 'customerId'),
        agentId: any(named: 'agentId'),
      ),
    ).thenAnswer(
      (_) async => _mockLimit,
    );
  });

  test('Should return limit', () async {
    final result = await _useCase();

    expect(result, _mockLimit);

    verify(
      () => _mock.load(
        customerId: any(named: 'customerId'),
        agentId: any(named: 'agentId'),
      ),
    ).called(1);
  });
}
