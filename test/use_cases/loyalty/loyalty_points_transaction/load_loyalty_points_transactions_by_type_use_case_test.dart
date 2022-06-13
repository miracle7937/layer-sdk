import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoyaltyPointsTransactionRepository extends Mock
    implements LoyaltyPointsTransactionRepositoryInterface {}

class MockLoyaltyPointsTransaction extends Mock
    implements LoyaltyPointsTransaction {}

late MockLoyaltyPointsTransactionRepository _repository;
late LoadLoyaltyPointsTransactionsByTypeUseCase _useCase;
late List<MockLoyaltyPointsTransaction> _mockedLoyaltyPointsTransactions;

final _transactionType = LoyaltyPointsTransactionType.burn;

void main() {
  setUp(() {
    _repository = MockLoyaltyPointsTransactionRepository();
    _useCase =
        LoadLoyaltyPointsTransactionsByTypeUseCase(repository: _repository);

    _mockedLoyaltyPointsTransactions = List.generate(
      5,
      (index) => MockLoyaltyPointsTransaction(),
    );

    when(
      () => _repository.listTransactions(
        transactionType: any(named: 'transactionType'),
      ),
    ).thenAnswer((_) async => _mockedLoyaltyPointsTransactions);
  });

  test('Should return a loyalty points transaction list', () async {
    final result = await _useCase(transactionType: _transactionType);

    expect(result, _mockedLoyaltyPointsTransactions);

    verify(
      () => _repository.listTransactions(transactionType: _transactionType),
    ).called(1);
  });
}
