import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A Cubit that handles the state for the loyalty redemption.
class AccountStatementCubit extends Cubit<AccountStatementState> {
  final GetAccountsByStatusUseCase _getAccountsByStatusUseCase;
  final RequestBankStatementUseCase _requestBankStatementUseCase;
  final ShareReceiptUseCase _shareReceiptUseCase;

  final String _customerId;

  /// Creates a new [AccountStatementCubit].
  AccountStatementCubit(
    this._customerId, {
    required GetAccountsByStatusUseCase getAccountsByStatusUseCase,
    required RequestBankStatementUseCase requestBankStatementUseCase,
    required ShareReceiptUseCase shareReceiptUseCase,
  })  : _getAccountsByStatusUseCase = getAccountsByStatusUseCase,
        _requestBankStatementUseCase = requestBankStatementUseCase,
        _shareReceiptUseCase = shareReceiptUseCase,
        super(AccountStatementState());

  /// Initializes the [AccountStatementCubit].
  Future<void> initialize() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(AccountStatementAction.accounts)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            AccountStatementAction.accounts,
          ),
          errors: state.removeErrorForAction(
            AccountStatementAction.accounts,
          ),
        ),
      );

      try {
        final accounts = await _getAccountsByStatusUseCase(
          statuses: [AccountStatus.active],
        );

        emit(
          state.copyWith(
            actions: state.removeAction(
              AccountStatementAction.accounts,
            ),
            accounts: accounts,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              AccountStatementAction.accounts,
            ),
            errors: state.addErrorFromException(
              action: AccountStatementAction.accounts,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Changing the start date of statement.
  void onChangeStartDate(
    DateTime dateTime,
  ) {
    emit(
      state.copyWith(
        events: state.addEvent(
          AccountStatementEvent.changingPeriod,
        ),
        startDate: dateTime,
      ),
    );
  }

  /// Changing the end date of statement.
  void onChangeEndDate(
    DateTime dateTime,
  ) {
    emit(
      state.copyWith(
        events: state.addEvent(
          AccountStatementEvent.changingPeriod,
        ),
        endDate: dateTime,
      ),
    );
  }

  /// Changing the period of statement.
  void onChangePeriod(
    DateTime start,
    DateTime end,
  ) {
    emit(
      state.copyWith(
        events: state.addEvent(
          AccountStatementEvent.changingPeriod,
        ),
        startDate: start,
        endDate: end,
      ),
    );
  }

  /// Requests a new bank statement
  /// Emits the file list of bytes when done
  Future<void> requestBankStatement() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          AccountStatementAction.statement,
        ),
        errors: state.removeErrorForAction(
          AccountStatementAction.statement,
        ),
      ),
    );

    final accountId = 'f6de0f2695443dbaf3a7470163164300aa1c065b';

    try {
      final bytes = await _requestBankStatementUseCase(
        accountId: accountId,
        // accountId: state.account!.id!,
        customerId: _customerId,
        fromDate: state.startDate!,
        toDate: state.endDate!,
        type: FileType.pdf,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            AccountStatementAction.accounts,
          ),
          events: state.addEvent(AccountStatementEvent.showResultView),
          certificateBytes: bytes,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AccountStatementAction.statement,
          ),
          errors: state.addErrorFromException(
            action: AccountStatementAction.statement,
            exception: e,
          ),
        ),
      );
    }
  }

  String _formattedDate(DateTime? dateTime) =>
      dateTime == null ? '' : DateFormat('yyyyMMdd').format(dateTime);

  /// Share statement.
  void shareStatement() {
    _shareReceiptUseCase(
      filename: 'statement_${state.account?.id}'
          '${_formattedDate(state.startDate)}${_formattedDate(state.endDate)}'
          '.pdf',
      bytes: state.statementBytes,
    );
  }
}
