import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

/// A cubit that handles the state for a pay to mobile transfer flow.
class PayToMobileTransferCubit extends Cubit<PayToMobileState> {
  final GetActiveAccountsSortedByAvailableBalance
      _getActiveAccountsSortedByAvailableBalance;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadCountriesUseCase _loadCountriesUseCase;

  /// Creates a new [PayToMobileTransferCubit].
  PayToMobileTransferCubit({
    required NewPayToMobileTransfer transfer,
    required GetActiveAccountsSortedByAvailableBalance
        getActiveAccountsSortedByAvailableBalance,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadCountriesUseCase loadCountriesUseCase,
  })  : _getActiveAccountsSortedByAvailableBalance =
            getActiveAccountsSortedByAvailableBalance,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadCountriesUseCase = loadCountriesUseCase,
        super(PayToMobileState(
          transfer: transfer,
        ));

  /// Initializes the cubit with the needed data required for the pay to mobile
  /// flow.
  Future<void> initialize() async {
    await Future.wait([
      _loadAccounts(),
      _loadCurrencies(),
      _loadCountries(),
    ]);

    if (state.accounts.isNotEmpty) {
      final account = state.accounts.first;
      final currency = state.currencies.singleWhereOrNull(
        (currency) => currency.code == account.currency,
      );

      onChanged(
        source: state.accounts.first,
        currency: currency,
      );
    }
  }

  /// Loads the accounts.
  Future<void> _loadAccounts() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(PayToMobileTransferAction.accounts)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileTransferAction.accounts,
          ),
          errors: state.removeErrorForAction(
            PayToMobileTransferAction.accounts,
          ),
        ),
      );

      try {
        final accounts = await _getActiveAccountsSortedByAvailableBalance();

        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransferAction.accounts,
            ),
            accounts: accounts,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransferAction.accounts,
            ),
            errors: state.addErrorFromException(
              action: PayToMobileTransferAction.accounts,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Loads all the currencies.
  Future<void> _loadCurrencies() async {
    if (state.currencies.isEmpty ||
        state.errors.contains(PayToMobileTransferAction.currencies)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileTransferAction.currencies,
          ),
          errors: state.removeErrorForAction(
            PayToMobileTransferAction.currencies,
          ),
        ),
      );

      try {
        final currencies = await _loadAllCurrenciesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransferAction.currencies,
            ),
            currencies: currencies,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransferAction.currencies,
            ),
            errors: state.addErrorFromException(
              action: PayToMobileTransferAction.currencies,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Loads all the countries.
  Future<void> _loadCountries() async {
    if (state.countries.isEmpty ||
        state.errors.contains(PayToMobileTransferAction.countries)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileTransferAction.countries,
          ),
          errors: state.removeErrorForAction(
            PayToMobileTransferAction.countries,
          ),
        ),
      );

      try {
        final countries = await _loadCountriesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransferAction.countries,
            ),
            countries: countries,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransferAction.countries,
            ),
            errors: state.addErrorFromException(
              action: PayToMobileTransferAction.countries,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Updates the transfer object.
  Future<void> onChanged({
    Account? source,
    String? destinationPhoneMobile,
    double? amount,
    Currency? currency,
    String? transactionCode,
    bool? saveToShortcut,
    String? shortcutName,
  }) async =>
      emit(
        state.copyWith(
          transfer: state.transfer.copyWith(
            source: source == null
                ? null
                : NewTransferSource(
                    account: source,
                  ),
            destinationPhoneNumber: destinationPhoneMobile,
            amount: amount,
            currency: currency,
            transactionCode: transactionCode,
            saveToShortcut: saveToShortcut,
            shortcutName: shortcutName,
          ),
        ),
      );

  /// Validates the pay to mobile transfer.
  Future<void> validate() async {
    emit(
      state.copyWith(
        errors: {},
        events: state.removeEvent(
          PayToMobileTransferEvent.showConfirmationView,
        ),
      ),
    );

    final validationErrors = _validateTransfer();
    if (validationErrors.isNotEmpty) {
      emit(
        state.copyWith(
          errors: state.addValidationErrors(validationErrors: validationErrors),
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        events: state.addEvent(
          PayToMobileTransferEvent.showConfirmationView,
        ),
      ),
    );
  }

  /// Validates the new transfer and returns the validation errors.
  Set<CubitValidationError<PayToMobileTransferValidationErrorCode>>
      _validateTransfer() {
    final validationErrors =
        <CubitValidationError<PayToMobileTransferValidationErrorCode>>{};

    final transfer = state.transfer;

    if (transfer.source?.account == null) {
      validationErrors.add(
        CubitValidationError<PayToMobileTransferValidationErrorCode>(
          validationErrorCode: PayToMobileTransferValidationErrorCode
              .sourceAccountValidationError,
        ),
      );
    }

    /// TODO: add destination phone number validation.

    if ((transfer.amount ?? 0.0) <= 0.0) {
      validationErrors.add(
        CubitValidationError<PayToMobileTransferValidationErrorCode>(
          validationErrorCode:
              PayToMobileTransferValidationErrorCode.amountValidationError,
        ),
      );
    }

    if ((transfer.amount ?? 0.0) >
        (transfer.source?.account?.availableBalance ?? 0.0)) {
      validationErrors.add(
        CubitValidationError<PayToMobileTransferValidationErrorCode>(
          validationErrorCode: PayToMobileTransferValidationErrorCode
              .insufficientBalanceValidationError,
        ),
      );
    }

    /// TODO: add transaction code validation.

    if (transfer.saveToShortcut &&
        (transfer.shortcutName ?? '').toString().isEmpty) {
      validationErrors.add(
        CubitValidationError<PayToMobileTransferValidationErrorCode>(
          validationErrorCode: PayToMobileTransferValidationErrorCode
              .shortcutNameValidationError,
        ),
      );
    }

    return validationErrors;
  }
}
