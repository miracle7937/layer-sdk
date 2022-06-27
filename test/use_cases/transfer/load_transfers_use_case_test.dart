import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/transfer.dart';
import 'package:mocktail/mocktail.dart';

class MockTransferRepository extends Mock
    implements TransferRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockTransferRepository _repository;
  late LoadTransfersUseCase _loadTransfersUseCase;

  final _mockedTransfers = List.generate(
    3,
    (index) => Transfer(),
  );

  setUp(() {
    _repository = MockTransferRepository();
    _loadTransfersUseCase = LoadTransfersUseCase(repository: _repository);

    when(
      () => _loadTransfersUseCase(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer(
      (_) async => _mockedTransfers,
    );
  });

  test('Should return a list of Transfers', () async {
    final response = await _loadTransfersUseCase(customerId: '1');

    expect(response, _mockedTransfers);

    verify(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
