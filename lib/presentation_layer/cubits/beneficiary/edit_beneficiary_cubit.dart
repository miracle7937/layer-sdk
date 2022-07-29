import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles editing of the beneficiary.
class EditBeneficiaryCubit extends Cubit<EditBeneficiaryState> {
  final EditBeneficiaryUseCase _editBeneficiaryUseCase;

  /// Creates a new cubit using the supplied [LoadAvailableCurrenciesUseCase].
  EditBeneficiaryCubit({
    required EditBeneficiaryUseCase editBeneficiariesUseCase,
    required Beneficiary editingBeneficiary,
  })  : _editBeneficiaryUseCase = editBeneficiariesUseCase,
        super(
          EditBeneficiaryState(
            oldBeneficiary: editingBeneficiary,
            beneficiary: editingBeneficiary.copyWith(),
          ),
        );

  /// Handles event of nickname changes.
  void onNicknameChange(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          nickname: text,
        ),
      );

  /// Handles event of first line of address changes.
  void onAddress1Change(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          address1: text,
        ),
      );

  /// Handles event of second line of address changes.
  void onAddress2Change(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          address2: text,
        ),
      );

  /// Handles event of third line of address changes.
  void onAddress3Change(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          address3: text,
        ),
      );

  void _emitBeneficiary(Beneficiary? beneficiary) => emit(
        state.copyWith(
          beneficiary: beneficiary,
          action: EditBeneficiaryAction.editAction,
          errorStatus: EditBeneficiaryErrorStatus.none,
        ),
      );

  /// Handles the editing of beneficiary.
  void onEdit() async {
    emit(
      state.copyWith(
        action: EditBeneficiaryAction.save,
        busy: true,
        errorStatus: EditBeneficiaryErrorStatus.none,
      ),
    );
    try {
      final hasAccount = state.hasAccount;
      final beneficiary = state.beneficiary.copyWith(
        accountNumber: hasAccount ? state.beneficiary.accountNumber! : '',
        sortCode: hasAccount ? state.beneficiary.sortCode! : '',
        iban: hasAccount ? '' : state.beneficiary.iban!,
      );
      await _editBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      emit(
        state.copyWith(
          busy: false,
          action: EditBeneficiaryAction.success,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: EditBeneficiaryAction.none,
          errorStatus: e is NetException
              ? EditBeneficiaryErrorStatus.network
              : EditBeneficiaryErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
