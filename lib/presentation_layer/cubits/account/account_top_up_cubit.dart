import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../domain_layer/use_cases.dart';
import '../../../features/accounts.dart';
import '../../cubits.dart';

/// Cubit that handles the Account top up flow.
class AccountTopUpCubit extends Cubit<AccountTopUpState> {
  final GetAccountTopUpSecretUseCase _accountTopUpSecretUseCase;
  final GetAccountTopUpReceiptUseCase _accountTopUpReceiptUseCase;

  /// Creates a new [AccountTopUpCubit] instance.
  AccountTopUpCubit({
    Account? account,
    double? amount,
    required GetAccountTopUpSecretUseCase accountTopUpSecretUseCase,
    required GetAccountTopUpReceiptUseCase accountTopUpReceiptUseCase,
  })  : _accountTopUpSecretUseCase = accountTopUpSecretUseCase,
        _accountTopUpReceiptUseCase = accountTopUpReceiptUseCase,
        super(
          AccountTopUpState(
            account: account,
            amount: amount ?? 0.0,
          ),
        );

  /// Sets the account that will be used on the top up.
  void setAccount({
    required Account account,
  }) =>
      emit(
        state.copyWith(
          account: account,
        ),
      );

  /// Sets the amount that will be topped up.
  void setAmount({
    required double amount,
  }) =>
      emit(
        state.copyWith(
          amount: amount,
        ),
      );

  /// Requests a new Stripe SDK secret key with the previously set parameters.
  Future<void> requestSecret() async {
    assert(state.account != null);
    assert(state.amount > 0);

    emit(
      state.copyWith(
        action: AccountTopUpActions.requestingSecret,
        error: AccountTopUpErrors.none,
        clearSecret: true,
      ),
    );

    try {
      final request = await _accountTopUpSecretUseCase(
        accountId: state.account!.id!,
        amount: state.amount,
        currency: state.account!.currency!,
      );

      emit(
        state.copyWith(
          action: AccountTopUpActions.none,
          error: AccountTopUpErrors.none,
          secret: request.clientSecret,
          topUpId: request.id,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AccountTopUpActions.none,
          error: AccountTopUpErrors.failedToRequestSecret,
        ),
      );
    }
  }

  /// Requests a new top up receipt.
  ///
  /// Can only be called when the top up was requested successfully.
  Future<void> requestReceipt({
    required ReceiptType type,
  }) async {
    assert(state.topUpId != null);

    emit(
      state.copyWith(
        action: type == ReceiptType.image
            ? AccountTopUpActions.requestingImageReceipt
            : AccountTopUpActions.requestingPdfReceipt,
        error: AccountTopUpErrors.none,
      ),
    );

    try {
      final bytes = await _accountTopUpReceiptUseCase(
        topUpId: state.topUpId!,
        type: type,
      );

      emit(
        state.copyWith(
          action: AccountTopUpActions.none,
          pdfReceipt: type == ReceiptType.pdf ? bytes : null,
          imageReceipt: type == ReceiptType.image ? bytes : null,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AccountTopUpActions.none,
          error: AccountTopUpErrors.failedToRequestReceipt,
        ),
      );
    }
  }
}
