import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockFinancialDataRepository extends Mock
    implements FinancialDataRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockFinancialDataRepository _repository;
  late LoadFinancialDataUseCase _loadFinancialDataUseCase;

  final _mockedFinancialData = FinancialData();

  setUp(() {
    _repository = MockFinancialDataRepository();
    _loadFinancialDataUseCase = LoadFinancialDataUseCase(
      repository: _repository,
    );

    when(() => _loadFinancialDataUseCase(customerId: any(named: 'customerId')))
        .thenAnswer(
      (_) async => _mockedFinancialData,
    );
  });

  test('Should return a Financial Data', () async {
    final response = await _loadFinancialDataUseCase(customerId: '1');

    expect(response, _mockedFinancialData);

    verify(
      () => _repository.loadFinancialData(
        customerId: any(
          named: 'customerId',
        ),
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
