import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories/card/card_repository_interface.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/card/load_customer_card_transactions_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockCardRepositoryInterface extends Mock
    implements CardRepositoryInterface {}

late MockCardRepositoryInterface _cardRepositoryInterface;
late LoadCustomerCardTransactionsUseCase _useCase;
late List<CardTransaction> _transactions;

void main() {
  _cardRepositoryInterface = MockCardRepositoryInterface();
  _useCase = LoadCustomerCardTransactionsUseCase(
    repository: _cardRepositoryInterface,
  );

  _transactions = List.generate(
    5,
    (index) => CardTransaction(
      transactionId: '$index',
    ),
  );

  setUpAll(
    () => {
      when(
        () => _cardRepositoryInterface.listCustomerCardTransactions(
          cardId: any(named: 'cardId'),
          customerId: any(named: 'customerId'),
        ),
      ).thenAnswer(
        (_) async => _transactions,
      )
    },
  );

  test('Should return correct cards list', () async {
    final result = await _useCase(
      cardId: 'testCardId',
      customerId: 'testCustomerId',
    );

    expect(result, _transactions);

    verify(
      () => _cardRepositoryInterface.listCustomerCardTransactions(
        cardId: 'testCardId',
        customerId: 'testCustomerId',
      ),
    ).called(1);
  });
}
