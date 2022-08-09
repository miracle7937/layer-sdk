import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles editing of the beneficiary.
class EditBeneficiaryCubit extends Cubit<EditBeneficiaryState> {
  final EditBeneficiaryUseCase _editBeneficiaryUseCase;
  final LoadBeneficiaryReceiptUseCase _loadBeneficiaryReceiptUseCase;
  final ShareReceiptUseCase _shareReceiptUseCase;

  /// Creates a new [EditBeneficiaryCubit].
  EditBeneficiaryCubit({
    required EditBeneficiaryUseCase editBeneficiariesUseCase,
    required LoadBeneficiaryReceiptUseCase loadBeneficiaryReceiptUseCase,
    required ShareReceiptUseCase shareReceiptUseCase,
    required Beneficiary editingBeneficiary,
  })  : _editBeneficiaryUseCase = editBeneficiariesUseCase,
        _loadBeneficiaryReceiptUseCase = loadBeneficiaryReceiptUseCase,
        _shareReceiptUseCase = shareReceiptUseCase,
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
          actions: _addAction(EditBeneficiaryAction.editAction),
          errors: _addError(
            action: EditBeneficiaryAction.editAction,
            errorStatus: EditBeneficiaryErrorStatus.none,
          ),
        ),
      );

  /// Handles the editing of beneficiary.
  void onEdit() async {
    emit(
      state.copyWith(
        actions: _addAction(
          EditBeneficiaryAction.save,
        ).difference(
          {EditBeneficiaryAction.otpRequired},
        ),
        errors: _addError(
          action: EditBeneficiaryAction.save,
          errorStatus: EditBeneficiaryErrorStatus.none,
        ),
      ),
    );
    try {
      final hasAccount = state.hasAccount;
      final beneficiary = state.beneficiary.copyWith(
        accountNumber: hasAccount ? state.beneficiary.accountNumber : '',
        routingCode: hasAccount ? state.beneficiary.routingCode : '',
        iban: hasAccount ? '' : state.beneficiary.iban,
      );
      final editedBeneficiary = await _editBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      emit(
        state.copyWith(
          beneficiary: editedBeneficiary,
          actions: {
            editedBeneficiary.otpId == null
                ? EditBeneficiaryAction.success
                : EditBeneficiaryAction.otpRequired
          },
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(EditBeneficiaryAction.save),
          errors: _addError(
            action: EditBeneficiaryAction.save,
            errorStatus: e is NetException
                ? EditBeneficiaryErrorStatus.network
                : EditBeneficiaryErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  /// Returns an error list that includes the passed action and error status.
  Set<EditBeneficiaryError> _addError({
    required EditBeneficiaryAction action,
    required EditBeneficiaryErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        EditBeneficiaryError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Returns an action list that includes the passed action.
  Set<EditBeneficiaryAction> _addAction(
    EditBeneficiaryAction action,
  ) =>
      state.actions.union({action});

  /// Returns an action list containing all the actions but the one that
  /// coincides with the passed action.
  Set<EditBeneficiaryAction> _removeAction(
    EditBeneficiaryAction action,
  ) =>
      state.actions.difference({action});

  /// Loads the beneficiary's receipt, if [isImage] true,
  /// then image, or PDF file.
  Future<void> loadReceipt({bool isImage = true}) async {
    emit(state.copyWith(
      actions: _addAction(EditBeneficiaryAction.receipt),
      errors: _addError(
        action: EditBeneficiaryAction.editAction,
        errorStatus: EditBeneficiaryErrorStatus.none,
      ),
    ));

    try {
      final receipt = await _loadBeneficiaryReceiptUseCase(
        state.beneficiary,
        isImage: isImage,
      );
      emit(state.copyWith(
        imageBytes: isImage ? receipt : state.imageBytes,
        pdfBytes: isImage ? state.pdfBytes : receipt,
        actions: _removeAction(EditBeneficiaryAction.receipt),
      ));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(EditBeneficiaryAction.receipt),
          errors: _addError(
            action: EditBeneficiaryAction.receipt,
            errorStatus: e is NetException
                ? EditBeneficiaryErrorStatus.network
                : EditBeneficiaryErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Share receipt, if [isImage] true,
  /// then image, or PDF file.
  void shareReceipt({bool isImage = true}) {
    _shareReceiptUseCase(
      filename: 'beneficiary_${state.beneficiary.id}_receipt.'
          '${isImage ? 'jpeg' : 'pdf'}',
      bytes: isImage ? state.imageBytes : state.pdfBytes,
    );
  }
}
