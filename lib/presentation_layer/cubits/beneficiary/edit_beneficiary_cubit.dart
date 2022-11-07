import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// TODO: cubit_issue | I feel like this is a clone of the [AddBeneficiaryCubit]
/// Whith some tweaks on the add beneficiary cubit, we could handle the editing
/// for the beneficiary.
/// A cubit that handles editing of the beneficiary.
class EditBeneficiaryCubit extends Cubit<EditBeneficiaryState> {
  final _logger = Logger('EditBeneficiaryCubit');

  final EditBeneficiaryUseCase _editBeneficiaryUseCase;
  final SendOTPCodeForBeneficiaryUseCase _sendOTPCodeForBeneficiaryUseCase;
  final VerifyBeneficiarySecondFactorUseCase
      _verifyBeneficiarySecondFactorUseCase;
  final ResendBeneficiarySecondFactorUseCase
      _resendBeneficiarySecondFactorUseCase;

  /// Creates a new [EditBeneficiaryCubit].
  EditBeneficiaryCubit({
    required EditBeneficiaryUseCase editBeneficiariesUseCase,
    required Beneficiary editingBeneficiary,
    required SendOTPCodeForBeneficiaryUseCase sendOTPCodeForBeneficiaryUseCase,
    required VerifyBeneficiarySecondFactorUseCase
        verifyBeneficiarySecondFactorUseCase,
    required ResendBeneficiarySecondFactorUseCase
        resendBeneficiarySecondFactorUseCase,
  })  : _editBeneficiaryUseCase = editBeneficiariesUseCase,
        _sendOTPCodeForBeneficiaryUseCase = sendOTPCodeForBeneficiaryUseCase,
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
        ),
      );

  /// Handles the editing of beneficiary.
  void onEdit() async {
    emit(
      state.copyWith(
        actions: state.addAction(EditBeneficiaryAction.save),
        errors: state.removeErrorForAction(EditBeneficiaryAction.save),
        events: state.removeEvents(
          const {
            EditBeneficiaryEvent.openSecondFactor,
            EditBeneficiaryEvent.showResultView,
          },
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

      final beneficiaryResult = await _editBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      switch (beneficiaryResult.status) {
        case BeneficiaryStatus.active:
        case BeneficiaryStatus.pending:
          emit(
            state.copyWith(
              beneficiaryResult: beneficiaryResult,
              actions: state.removeAction(EditBeneficiaryAction.save),
              events: state.addEvent(EditBeneficiaryEvent.showResultView),
            ),
          );
          break;

        case BeneficiaryStatus.otp:
          emit(
            state.copyWith(
              beneficiaryResult: beneficiaryResult,
              actions: state.removeAction(EditBeneficiaryAction.save),
              events: state.addEvent(EditBeneficiaryEvent.openSecondFactor),
            ),
          );
          break;

        default:
          _logger.severe(
            'Unhandled beneficiary status -> ${beneficiaryResult.status}',
          );
          throw Exception(
            'Unhandled beneficiary status -> ${beneficiaryResult.status}',
          );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(EditBeneficiaryAction.save),
          errors: state.addErrorFromException(
            action: EditBeneficiaryAction.save,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current beneficiary.
  Future<void> sendOTPCode() async {
    assert(state.beneficiaryResult != null);
    if (state.beneficiaryResult == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(
          EditBeneficiaryAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          EditBeneficiaryAction.sendOTPCode,
        ),
        events: state.removeEvent(
          EditBeneficiaryEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final beneficiaryResult = await _sendOTPCodeForBeneficiaryUseCase(
        beneficiary: state.beneficiaryResult!,
        isEditing: true,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            EditBeneficiaryAction.sendOTPCode,
          ),
          beneficiaryResult: beneficiaryResult,
          events: state.addEvent(
            EditBeneficiaryEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            EditBeneficiaryAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: EditBeneficiaryAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the beneficiary retrievied on the [onEdit]
  /// method.
  Future<void> verifySecondFactor({
    String? otpCode,
    String? ocraClientResponse,
  }) async {
    assert(
      otpCode != null || ocraClientResponse != null,
      'An OTP code or OCRA client response must be provided in order for '
      'verifying the second factor',
    );

    assert(state.beneficiaryResult != null);
    if (state.beneficiaryResult == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(
          EditBeneficiaryAction.verifySecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final beneficiaryResult = await _verifyBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiaryResult!,
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
        isEditing: true,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            EditBeneficiaryAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          beneficiaryResult: beneficiaryResult,
          events: state.addEvent(
            EditBeneficiaryEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            EditBeneficiaryAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: EditBeneficiaryAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resends the second factor for the beneficiary retrievied on the [onEdit]
  /// method.
  Future<void> resendSecondFactor() async {
    assert(state.beneficiaryResult != null);
    if (state.beneficiaryResult == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(
          EditBeneficiaryAction.resendSecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final beneficiaryResult = await _resendBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiaryResult!,
        isEditing: true,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            EditBeneficiaryAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          beneficiaryResult: beneficiaryResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            EditBeneficiaryAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: EditBeneficiaryAction.resendSecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }
}
