import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A Cubit that handles the state for the loyalty redemption.
class AccountStatementCubit extends Cubit<AccountStatementState> {
  final RequestBankStatementUseCase _requestBankStatementUseCase;
  final ShareReceiptUseCase _shareReceiptUseCase;

  final String _customerId;
  final String _accountId;

  /// Creates a new [AccountStatementCubit].
  AccountStatementCubit(
    this._customerId,
    this._accountId, {
    required RequestBankStatementUseCase requestBankStatementUseCase,
    required ShareReceiptUseCase shareReceiptUseCase,
  })  : _requestBankStatementUseCase = requestBankStatementUseCase,
        _shareReceiptUseCase = shareReceiptUseCase,
        super(AccountStatementState());

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
  ///
  /// The end date is inclusive, meaning that a day will be added when
  /// requesting the statement so the selected end date is included.
  ///
  /// For example: If `DateTime(2023, 05, 01)` is selected, the date sent will
  /// be `DateTime(2023, 05, 02)` so the selected date is included in the
  /// statement.
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

    try {
      final bytes = await _requestBankStatementUseCase(
        accountId: _accountId,
        customerId: _customerId,
        fromDate: state.startDate!,
        toDate: state.endDate!.add(Duration(days: 1)),
        type: FileType.pdf,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            AccountStatementAction.statement,
          ),
          events: state.addEvent(AccountStatementEvent.showResultView),
          statementBytes: bytes,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
      filename: 'statement_$_accountId'
          '${_formattedDate(state.startDate)}${_formattedDate(state.endDate)}'
          '.pdf',
      bytes: state.statementBytes,
    );
  }
}
