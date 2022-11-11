import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../../domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
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
  final GetPreselectedAccountForOwnTransferUseCase
      _getPreselectedAccountForOwnTransferUseCase;

  /// Creates new [OwnTransferCubit].
  ///
  /// The `editMode` param is defined to update/edit the selected transfer
  /// Case `true` the API will `PATCH` the transfer
  OwnTransferCubit({
    OwnTransfer? transfer,
    bool editMode = false,
    required GetSourceAccountsForOwnTransferUseCase
        getSourceAccountsForOwnTransferUseCase,
    required GetDestinationAccountsForOwnTransferUseCase
        getDestinationAccountsForOwnTransferUseCase,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required SubmitTransferUseCase submitTransferUseCase,
    required GenerateDeviceUIDUseCase generateDeviceUIDUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    required GetPreselectedAccountForOwnTransferUseCase
        getPreselectedAccountForOwnTransferUseCase,
  })  : _getSourceAccountsForOwnTransferUseCase =
            getSourceAccountsForOwnTransferUseCase,
        _getDestinationAccountsForOwnTransferUseCase =
            getDestinationAccountsForOwnTransferUseCase,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _submitTransferUseCase = submitTransferUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        _getPreselectedAccountForOwnTransferUseCase =
            getPreselectedAccountForOwnTransferUseCase,
        super(
          OwnTransferState(
            transfer: transfer ?? OwnTransfer(),
            editMode: editMode,
            deviceUID: generateDeviceUIDUseCase(30),
          ),
        );

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
      final fromAccounts = results[0] as List<Account>;
      final toAccounts = results[1] as List<Account>;
      final currencies = results[2] as List<Currency>;
      final preselectedAccount = fromAccounts.isNotEmpty
          ? _getPreselectedAccountForOwnTransferUseCase(fromAccounts)
          : null;

      emit(state.copyWith(
        fromAccounts: fromAccounts,
        toAccounts: toAccounts,
        preselectedAccount: preselectedAccount,
        currencies: currencies,
        transfer: state.transfer.copyWith(
          deviceUID: state.deviceUID,
          source: fromAccounts.isNotEmpty
              ? NewTransferSource(account: preselectedAccount)
              : null,
          currency: fromAccounts.isNotEmpty
              ? currencies.firstWhereOrNull(
                  (currency) =>
                      currency.code?.toLowerCase() ==
                      preselectedAccount?.currency?.toLowerCase(),
                )
              : null,
        ),
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
    ScheduleDetails? scheduleDetails,
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
        scheduleDetails: scheduleDetails,
      ),
    ));
  }

  /// Validates Amount
  void validateFunds() {
    if (state.transfer.amount != null &&
        state.transfer.source?.account?.availableBalance != null &&
        state.transfer.amount! >
            state.transfer.source!.account!.availableBalance!) {
      emit(
        state.copyWith(
          errors: state.errors.union({
            OwnTransferAction.validatingFunds,
          }),
        ),
      );
    } else {
      emit(
        state.copyWith(
          errors: state.errors.difference({
            OwnTransferAction.validatingFunds,
          }),
        ),
      );
    }
  }

  /// Submits the transfer.
  Future<void> submit() async {
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
      if (state.transfer.saveToShortcut) {
        await _createShortcut();
      }

      final transferResult = await _submitTransferUseCase(
        transfer: state.transfer,
        editMode: state.editMode,
      );

      switch (transferResult.status) {
        case TransferStatus.completed:
        case TransferStatus.pending:
        case TransferStatus.scheduled:
          emit(
            state.copyWith(
              actions: state.actions.difference({
                OwnTransferAction.submit,
              }),
              resultStatus: transferResult.status,
              transferId: transferResult.id,
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
  Future<void> _createShortcut() async {
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
