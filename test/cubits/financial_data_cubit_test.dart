import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockFinancialDataRepository extends Mock
    implements FinancialDataRepository {}

final _repository = MockFinancialDataRepository();

final _successId = '1';
final _failureId = '2';

void main() {
  EquatableConfig.stringify = true;

  final _mockFinancialData = FinancialData(
    availableCredit: 30.0,
    cardBalance: 20.0,
    prefCurrency: 'BRL',
  );

  when(
    () => _repository.loadFinancialData(
      customerId: _successId,
      forceRefresh: true,
    ),
  ).thenAnswer(
    (_) async => _mockFinancialData,
  );

  when(
    () => _repository.loadFinancialData(
      customerId: _successId,
      forceRefresh: false,
    ),
  ).thenAnswer(
    (_) async => _mockFinancialData,
  );

  when(
    () => _repository.loadFinancialData(customerId: _failureId),
  ).thenAnswer(
    (_) async => throw Exception('Some error'),
  );

  blocTest<FinancialDataCubit, FinancialDataState>(
    'Starts with empty state',
    build: () => FinancialDataCubit(
      customerId: _successId,
      repository: _repository,
    ),
    verify: (c) => expect(
      c.state,
      FinancialDataState(
        customerId: _successId,
      ),
    ),
  ); // Starts with empty state

  blocTest<FinancialDataCubit, FinancialDataState>(
    'Load retrieves the customer financial data successfully',
    build: () => FinancialDataCubit(
      customerId: _successId,
      repository: _repository,
    ),
    act: (c) => c.load(),
    expect: () => [
      FinancialDataState(
        busy: true,
        customerId: _successId,
      ),
      FinancialDataState(
        busy: false,
        customerId: _successId,
        error: FinancialDataStateErrors.none,
        financialData: _mockFinancialData,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.loadFinancialData(
          customerId: _successId,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // Load retrieves the customer financial data successfully

  blocTest<FinancialDataCubit, FinancialDataState>(
    'Load with force refresh',
    build: () => FinancialDataCubit(
      customerId: _successId,
      repository: _repository,
    ),
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      FinancialDataState(
        busy: true,
        customerId: _successId,
      ),
      FinancialDataState(
        busy: false,
        customerId: _successId,
        error: FinancialDataStateErrors.none,
        financialData: _mockFinancialData,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.loadFinancialData(
          customerId: _successId,
          forceRefresh: true,
        ),
      ).called(1);
    },
  ); // Load retrieves the customer financial data successfully

  blocTest<FinancialDataCubit, FinancialDataState>(
    'Load emits error on failure',
    build: () => FinancialDataCubit(
      customerId: _failureId,
      repository: _repository,
    ),
    act: (c) => c.load(),
    errors: () => [
      isA<Exception>(),
    ],
    expect: () => [
      FinancialDataState(
        busy: true,
        customerId: _failureId,
      ),
      FinancialDataState(
        busy: false,
        customerId: _failureId,
        error: FinancialDataStateErrors.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.loadFinancialData(customerId: _failureId),
      ).called(1);
    },
  ); // Load emits error on failure
}
