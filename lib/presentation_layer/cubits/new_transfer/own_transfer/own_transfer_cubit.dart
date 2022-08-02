import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

/// The cubit managing the own transfer flow.
class OwnTransferCubit extends Cubit<OwnTransferState> {
  final GetSourceAccountsForOwnTransferUseCase
      _getSourceAccountsForOwnTransferUseCase;
  final GetDestinationAccountsForOwnTransferUseCase
      _getDestinationAccountsForOwnTransferUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final SubmitTransferUseCase _submitTransferUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;

  /// Creates new [OwnTransferCubit].
  OwnTransferCubit({
    required GetSourceAccountsForOwnTransferUseCase
        getSourceAccountsForOwnTransferUseCase,
    required GetDestinationAccountsForOwnTransferUseCase
        getDestinationAccountsForOwnTransferUseCase,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required SubmitTransferUseCase submitTransferUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
  })  : _getSourceAccountsForOwnTransferUseCase =
            getSourceAccountsForOwnTransferUseCase,
        _getDestinationAccountsForOwnTransferUseCase =
            getDestinationAccountsForOwnTransferUseCase,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _submitTransferUseCase = submitTransferUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        super(OwnTransferState(transfer: OwnTransfer()));

  /// Fetches all the data necessary to start the flow.
  Future<void> initialize() async {
    emit(state.copyWith(
      actions: state.actions.union({
        OwnTransferAction.accounts,
      }),
      errors: state.errors.difference({
        OwnTransferAction.accounts,
      }),
    ));

    try {
      final results = await Future.wait<dynamic>(
        [
          _getSourceAccountsForOwnTransferUseCase(),
          _getDestinationAccountsForOwnTransferUseCase(),
          _loadAllCurrenciesUseCase(),
        ],
      );
      final fromAccounts = results[0];
      final toAccounts = results[1];
      final currencies = results[2];

      emit(state.copyWith(
        fromAccounts: fromAccounts,
        toAccounts: toAccounts,
        currencies: currencies,
        actions: state.actions.difference({
          OwnTransferAction.accounts,
        }),
      ));
    } on Exception {
      emit(state.copyWith(
        actions: state.actions.difference({
          OwnTransferAction.accounts,
        }),
        errors: state.errors.union({
          OwnTransferAction.accounts,
        }),
      ));
    }
  }

  /// Updates the transfer properties in the state.
  void onChanged({
    Account? fromAccount,
    Account? toAccount,
    double? amount,
    bool? saveToShortcut,
    String? shortcutName,
  }) {
    emit(state.copyWith(
      transfer: state.transfer.copyWith(
        source: fromAccount != null
            ? NewTransferSource(account: fromAccount)
            : null,
        destination: toAccount != null
            ? NewTransferDestination(account: toAccount)
            : null,
        currency: fromAccount != null
            ? state.currencies.firstWhereOrNull(
                (currency) =>
                    currency.code?.toLowerCase() ==
                    fromAccount.currency?.toLowerCase(),
              )
            : null,
        amount: amount,
        saveToShortcut: saveToShortcut,
        shortcutName: shortcutName,
      ),
    ));
  }

  /// Submits the transfer.
  Future<void> submit({
    required NewTransfer transfer,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({
          OwnTransferAction.submit,
        }),
        errors: state.errors.difference({
          OwnTransferAction.submit,
        }),
        clearErrorMessage: true,
      ),
    );

    try {
      final transferResult = await _submitTransferUseCase(
        transfer: state.transfer,
      );

      switch (transferResult.status) {
        case TransferStatus.completed:
        case TransferStatus.pending:
        case TransferStatus.scheduled:
          if (state.transfer.saveToShortcut) {
            await _createShortcut(state.transfer);
          }

          emit(
            state.copyWith(
              actions: state.actions.difference({
                OwnTransferAction.submit,
              }),
              resultStatus: transferResult.status,
            ),
          );
          break;

        case TransferStatus.failed:
        case TransferStatus.cancelled:
        case TransferStatus.rejected:
        case TransferStatus.pendingExpired:
        case TransferStatus.otp:
        case TransferStatus.otpExpired:
        case TransferStatus.deleted:
        case null:
          emit(
            state.copyWith(
              actions: state.actions.difference(
                {OwnTransferAction.submit},
              ),
              errors: state.errors.union(
                {OwnTransferAction.submit},
              ),
            ),
          );
          break;
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.actions.difference(
            {OwnTransferAction.submit},
          ),
          errors: state.errors.union(
            {OwnTransferAction.submit},
          ),
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  /// Creates the shortcut (if enabled) once the transfer has succeeded.
  Future<void> _createShortcut(
    OwnTransfer transfer,
  ) async {
    emit(
      state.copyWith(
        actions: state.actions.union({
          OwnTransferAction.shortcut,
        }),
        errors: state.errors.difference({
          OwnTransferAction.shortcut,
        }),
      ),
    );

    try {
      await _createShortcutUseCase(
        shortcut: NewShortcut(
          name: state.transfer.shortcutName!,
          type: ShortcutType.transfer,
          payload: state.transfer,
        ),
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({
            OwnTransferAction.shortcut,
          }),
        ),
      );
    } on Exception {
      emit(state.copyWith(
        actions: state.actions.difference({
          OwnTransferAction.shortcut,
        }),
        errors: state.errors.union({
          OwnTransferAction.shortcut,
        }),
      ));
    }
  }
}
