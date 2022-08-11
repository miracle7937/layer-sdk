import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/use_cases/transfer/transfer_receipt_use_case.dart';
import 'package:layer_sdk/features/transfer.dart';
import 'package:mocktail/mocktail.dart';

class MockTransferRepository extends Mock
    implements TransferRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockTransferRepository _repository;
  late TransferReceiptUseCase _transferReceiptUseCase;

  final _mockedReceipt = [1, 2, 3];

  setUp(() {
    _repository = MockTransferRepository();
    _transferReceiptUseCase =
        TransferReceiptUseCase(transferRepository: _repository);

    when(
      () => _transferReceiptUseCase(
        transferId: any(named: 'transferId'),
      ),
    ).thenAnswer(
      (_) async => _mockedReceipt,
    );
  });

  test('Should return a Receipt of transfer', () async {
    final response = await _transferReceiptUseCase(transferId: 1);

    expect(response, _mockedReceipt);

    verify(
      () => _repository.getTransferReceipt(
        transferId: any(named: 'transferId'),
      ),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
