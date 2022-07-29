import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles editing of the beneficiary.
class EditBeneficiaryCubit extends Cubit<EditBeneficiaryState> {
  final EditBeneficiaryUseCase _editBeneficiaryUseCase;
  final VerifyBeneficiarySecondFactorUseCase
      _verifyBeneficiarySecondFactorUseCase;
  final ResendBeneficiarySecondFactorUseCase
      _resendBeneficiarySecondFactorUseCase;

  /// Creates a new cubit using the supplied [LoadAvailableCurrenciesUseCase].
  EditBeneficiaryCubit({
    required EditBeneficiaryUseCase editBeneficiariesUseCase,
    required VerifyBeneficiarySecondFactorUseCase
        verifyBeneficiarySecondFactorUseCase,
    required ResendBeneficiarySecondFactorUseCase
        resendBeneficiarySecondFactorUseCase,
    required Beneficiary editingBeneficiary,
  })  : _editBeneficiaryUseCase = editBeneficiariesUseCase,
        _verifyBeneficiarySecondFactorUseCase =
            verifyBeneficiarySecondFactorUseCase,
        _resendBeneficiarySecondFactorUseCase =
            resendBeneficiarySecondFactorUseCase,
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
      final editedBeneficiary = await _editBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      emit(
        state.copyWith(
          beneficiary: editedBeneficiary,
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

  /// Verifies the second factor for the edited beneficiary
  /// retrieved on the [onEdit] method.
  Future<void> verifySecondFactor({
    required String otpValue,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        action: EditBeneficiaryAction.verifyOtp,
        errorStatus: EditBeneficiaryErrorStatus.none,
      ),
    );

    try {
      final beneficiary = await _verifyBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary,
        otpValue: otpValue,
        isEditing: true,
      );

      emit(
        state.copyWith(
          beneficiary: beneficiary,
          busy: false,
          action: EditBeneficiaryAction.none,
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
    }
  }

  /// Verifies the second factor for the edited beneficiary
  /// retrieved on the [onEdit] method.
  Future<void> resendSecondFactor() async {
    emit(
      state.copyWith(
        busy: true,
        action: EditBeneficiaryAction.resendOtp,
        errorStatus: EditBeneficiaryErrorStatus.none,
      ),
    );

    try {
      final beneficiary = await _resendBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary,
        isEditing: true,
      );

      emit(
        state.copyWith(
          beneficiary: beneficiary,
          busy: false,
          action: EditBeneficiaryAction.none,
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
    }
  }
}
