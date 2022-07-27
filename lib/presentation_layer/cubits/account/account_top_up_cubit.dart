import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit that handles the Account top up flow.
class AccountTopUpCubit extends Cubit<AccountTopUpState> {
  final GetAccountTopUpSecretUseCase _accountTopUpSecretUseCase;

  /// Creates a new [AccountTopUpCubit] instance.
  AccountTopUpCubit({
    required GetAccountTopUpSecretUseCase accountTopUpSecretUseCase,
  })  : _accountTopUpSecretUseCase = accountTopUpSecretUseCase,
        super(
          AccountTopUpState(),
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
      final secret = await _accountTopUpSecretUseCase(
        accountId: state.account!.id!,
        amount: state.amount,
        currency: state.account!.currency!,
      );

      emit(
        state.copyWith(
          action: AccountTopUpActions.none,
          error: AccountTopUpErrors.none,
          secret: secret,
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
}
