import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/standing_orders.dart';
import 'package:mocktail/mocktail.dart';

class MockStandingOrdersRepository extends Mock
    implements StandingOrdersRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockStandingOrdersRepository _repository;
  late LoadStandingOrdersUseCase _loadStandingOrdersUseCase;

  final _mockedStandingOrders = List.generate(
    3,
    (index) => StandingOrder(),
  );

  setUp(() {
    _repository = MockStandingOrdersRepository();
    _loadStandingOrdersUseCase = LoadStandingOrdersUseCase(
      repository: _repository,
    );

    when(() => _loadStandingOrdersUseCase(customerId: any(named: 'customerId')))
        .thenAnswer(
      (_) async => _mockedStandingOrders,
    );
  });

  test('Should return a list of Standing orders', () async {
    final response = await _loadStandingOrdersUseCase(customerId: '1');

    expect(response, _mockedStandingOrders);

    verify(() => _repository.list(customerId: any(named: 'customerId')));

    verifyNoMoreInteractions(_repository);
  });
}
