import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:mocktail/mocktail.dart';

class MockValidateTransactionPinUseCase extends Mock
    implements ValidateTransactionPinUseCase {}

late ValidatorCubit _cubit;

late ValidateTransactionPinUseCase _validateTransactionPinUseCase;

void main() {
  setUp(() {
    _validateTransactionPinUseCase = MockValidateTransactionPinUseCase();

    _cubit = ValidatorCubit(
      validateTransactionPinUseCase: _validateTransactionPinUseCase,
    );

    when(() => _validateTransactionPinUseCase(
          txnPin: any(named: 'txnPin'),
          userId: any(named: 'userId'),
        )).thenAnswer(
      (_) async => true,
    );
  });

  blocTest<ValidatorCubit, ValidatorState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      ValidatorState(
        actions: {},
        errors: {},
      ),
    ),
  );
}
