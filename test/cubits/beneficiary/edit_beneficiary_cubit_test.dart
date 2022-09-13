import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/features/beneficiaries.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockBeneficiaryRepositoryInterface extends Mock
    implements BeneficiaryRepositoryInterface {}

late MockBeneficiaryRepositoryInterface _repo;
late Beneficiary _benef;
late EditBeneficiaryCubit _cubit;
late EditBeneficiaryUseCase _useCase;
late EditBeneficiaryState _baseState;

String _newNickName = 'New Banco';
String _onAddress1Change = 'new Address 1 Change';
String _onAddress2Change = 'new Address 2 Change';
String _onAddress3Change = 'new Address 3 Change';

final _exception = Exception('error 123');
final _netException = NetException(message: 'error 123');

void main() {
  setUpAll(() {
    _benef = Beneficiary(
      bankName: 'Banco',
      firstName: 'John',
      lastName: 'Banana',
      middleName: 'Ripe',
      nickname: 'John Cake',
    );

    _baseState = EditBeneficiaryState(
      beneficiary: _benef,
      oldBeneficiary: _benef,
      actions: {EditBeneficiaryAction.editAction},
      errors: {
        EditBeneficiaryError(
          action: EditBeneficiaryAction.editAction,
          errorStatus: EditBeneficiaryErrorStatus.none,
        )
      },
    );

    _repo = MockBeneficiaryRepositoryInterface();
    _useCase = EditBeneficiaryUseCase(beneficiaryRepository: _repo);
    _cubit = EditBeneficiaryCubit(
      editBeneficiariesUseCase: _useCase,
      editingBeneficiary: _benef,
    );

    registerFallbackValue(_benef);

    when(
      () => _repo.edit(
          beneficiary: any(named: 'beneficiary'), forceRefresh: false),
    ).thenAnswer(
      (_) async => _benef,
    );
  });

  group('Test setters', () {
    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'Should change beneficiary nickname',
      build: () => _cubit,
      act: (b) => b.onNicknameChange(_newNickName),
      expect: () => [
        EditBeneficiaryState(
          beneficiary: _benef.copyWith(nickname: _newNickName),
          oldBeneficiary: _benef,
          actions: {EditBeneficiaryAction.editAction},
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            )
          },
        ),
      ],
    );
    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'Should change beneficiary address1',
      build: () => _cubit,
      act: (b) => b.onAddress1Change(_onAddress1Change),
      expect: () => [
        EditBeneficiaryState(
          beneficiary: _benef.copyWith(address1: _onAddress1Change),
          oldBeneficiary: _benef,
          actions: {EditBeneficiaryAction.editAction},
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            )
          },
        ),
      ],
    );
    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'Should change beneficiary address2',
      build: () => _cubit,
      act: (b) => b.onAddress2Change(_onAddress2Change),
      expect: () => [
        EditBeneficiaryState(
          beneficiary: _benef.copyWith(address2: _onAddress2Change),
          oldBeneficiary: _benef,
          actions: {EditBeneficiaryAction.editAction},
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            )
          },
        ),
      ],
    );
    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'Should change beneficiary address3',
      build: () => _cubit,
      act: (b) => b.onAddress3Change(_onAddress3Change),
      expect: () => [
        EditBeneficiaryState(
          beneficiary: _benef.copyWith(address3: _onAddress3Change),
          oldBeneficiary: _benef,
          actions: {EditBeneficiaryAction.editAction},
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            )
          },
        ),
      ],
    );
  });
  group('Test Edit', () {
    setUp(() {
      when(
        () => _repo.edit(
            beneficiary: any(named: 'beneficiary'), forceRefresh: false),
      ).thenAnswer(
        (_) async => _benef,
      );
    });

    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'should edit a beneficiary',
      seed: () => _baseState.copyWith(
        beneficiary: _benef,
      ),
      build: () => _cubit,
      act: (c) => c.onEdit(),
      expect: () => [
        _baseState.copyWith(
          actions: {
            EditBeneficiaryAction.editAction,
            EditBeneficiaryAction.save,
          },
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
          },
        ),
        _baseState.copyWith(
          actions: {
            EditBeneficiaryAction.success,
          },
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
          },
        )
      ],
      verify: (a) {
        verify(
          () => _repo.edit(
            beneficiary: any(named: 'beneficiary'),
            forceRefresh: false,
          ),
        ).called(1);
      },
    );
  });
  group('Test Exception', () {
    setUp(() {
      when(
        () => _repo.edit(
          beneficiary: any(named: 'beneficiary'),
          forceRefresh: false,
        ),
      ).thenThrow(_exception);
    });
    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'should edit a beneficiary',
      seed: () => _baseState.copyWith(
        beneficiary: _benef,
      ),
      build: () => _cubit,
      act: (c) => c.onEdit(),
      expect: () => [
        _baseState.copyWith(
          actions: {
            EditBeneficiaryAction.editAction,
            EditBeneficiaryAction.save,
          },
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
          },
        ),
        _baseState.copyWith(
          actions: {
            EditBeneficiaryAction.editAction,
          },
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.generic,
            ),
          },
        )
      ],
      errors: () => [
        isA<Exception>(),
      ],
      verify: (a) {
        verify(
          () => _repo.edit(
            beneficiary: any(named: 'beneficiary'),
            forceRefresh: false,
          ),
        ).called(1);
      },
    );
  });
  group('Test NetException', () {
    setUp(() {
      when(
        () => _repo.edit(
          beneficiary: any(named: 'beneficiary'),
          forceRefresh: false,
        ),
      ).thenThrow(_netException);
    });
    blocTest<EditBeneficiaryCubit, EditBeneficiaryState>(
      'should throw an netexception',
      seed: () => _baseState.copyWith(
        beneficiary: _benef,
      ),
      build: () => _cubit,
      act: (c) => c.onEdit(),
      expect: () => [
        _baseState.copyWith(
          actions: {
            EditBeneficiaryAction.editAction,
            EditBeneficiaryAction.save,
          },
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
          },
        ),
        _baseState.copyWith(
          actions: {
            EditBeneficiaryAction.editAction,
          },
          errors: {
            EditBeneficiaryError(
              action: EditBeneficiaryAction.editAction,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.none,
            ),
            EditBeneficiaryError(
              action: EditBeneficiaryAction.save,
              errorStatus: EditBeneficiaryErrorStatus.network,
              message: _netException.message,
            ),
          },
        )
      ],
      errors: () => [
        isA<NetException>(),
      ],
      verify: (a) {
        verify(
          () => _repo.edit(
            beneficiary: any(named: 'beneficiary'),
            forceRefresh: false,
          ),
        ).called(1);
      },
    );
  });
}
