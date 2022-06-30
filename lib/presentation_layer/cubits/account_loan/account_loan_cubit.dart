import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [AccountLoan]
class AccountLoansCubit extends Cubit<AccountLoanState> {
  final GetAccountLoansUseCase _getAccountLoansUseCase;
  final GetCustomerAccountLoansUseCase _getCustomerAccountLoansUseCase;
  final GetAccountLoanByIdUseCase _getAccountLoanByIdUseCase;

  /// Creates a new instance of [AccountTransactionsCubit]
  AccountLoansCubit({
    required GetAccountLoansUseCase getAccountLoansUseCase,
    required GetCustomerAccountLoansUseCase getCustomerAccountLoansUseCase,
    required GetAccountLoanByIdUseCase getAccountLoanByIdUseCase,
    String? customerId,
    int limit = 50,
  })  : _getAccountLoansUseCase = getAccountLoansUseCase,
        _getCustomerAccountLoansUseCase = getCustomerAccountLoansUseCase,
        _getAccountLoanByIdUseCase = getAccountLoanByIdUseCase,
        super(
          AccountLoanState(
            customerId: customerId,
            limit: limit,
          ),
        );

  /// Loads all account loans with the [customerId] supplied when creating
  /// the cubit.
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
    );

    try {
      final offset = loadMore ? state.offset + state.limit : 0;

      if (state.customerId == null) {
        emit(
          state.copyWith(
            busy: false,
          ),
        );

        return;
      }

      final loans = await _getCustomerAccountLoansUseCase(
        customerId: state.customerId!,
        offset: offset,
        limit: state.limit,
        forceRefresh: forceRefresh,
      );

      final list = offset > 0
          ? [
              ...state.loans.take(offset).toList(),
              ...loans,
            ]
          : loans;

      emit(
        state.copyWith(
          loans: list,
          busy: false,
          canLoadMore: loans.length >= state.limit,
          offset: offset,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: AccountLoanStateErrors.generic,
        ),
      );

      rethrow;
    }
  }

  /// Loads the account loans and payments for the provided [accountIds].
  ///
  /// Emits a busy state while loading.
  /// This method will always return all loans for the specified [accountIds]
  /// no matter what [limit] was supplied when creating the cubit.
  Future<void> loadByAccountIds({
    required List<String> accountIds,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
    );

    try {
      final loans = <AccountLoan>[];
      for (final id in accountIds) {
        final accountLoans = await _getAccountLoansUseCase(
          accountId: id,
          includeDetails: true,
          forceRefresh: forceRefresh,
        );

        loans.addAll(accountLoans);
      }

      emit(
        state.copyWith(
          busy: false,
          loans: loans,
          error: AccountLoanStateErrors.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: AccountLoanStateErrors.generic,
        ),
      );

      rethrow;
    }
  }

  /// Loads the an account loan by its id.
  ///
  /// Emits a busy state while loading.
  Future<void> loadById({
    required int id,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
    );

    try {
      final accountLoan = await _getAccountLoanByIdUseCase(
        id: id,
        includeDetails: true,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          busy: false,
          loans: [accountLoan],
          error: AccountLoanStateErrors.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: AccountLoanStateErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
