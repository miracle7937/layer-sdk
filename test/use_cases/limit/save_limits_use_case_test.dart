import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockLimitsRepositoryInterface extends Mock
    implements LimitsRepositoryInterface {}

late SaveLimitsUseCase _useCase;
late MockLimitsRepositoryInterface _mock;
late QueueRequest _mockRequest;
late Limits _mockLimit;

void main() {
  setUp(() {
    _mock = MockLimitsRepositoryInterface();
    _useCase = SaveLimitsUseCase(
      repository: _mock,
    );

    _mockRequest = QueueRequest(
      id: 'someId',
    );

    _mockLimit = Limits(
      originalLimitsNotEmpty: true,
      limCumulativeDaily: 10,
    );

    when(
      () => _useCase(
        customerId: any(named: 'customerId'),
        agentId: any(named: 'agentId'),
        customerType: CustomerType.corporate,
        limits: _mockLimit,
      ),
    ).thenAnswer(
      (_) async => _mockRequest,
    );
  });

  test('Should return request', () async {
    final result = await _useCase(
      customerType: CustomerType.corporate,
      limits: _mockLimit,
    );

    expect(result, _mockRequest);

    verify(
      () => _mock.save(
        customerId: any(named: 'customerId'),
        agentId: any(named: 'agentId'),
        customerType: CustomerType.corporate,
        limits: _mockLimit,
      ),
    ).called(1);
  });
}
