import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';

/// A cubit that handles the state for a pay to mobile transfer flow.
class PayToMobileCubit extends Cubit<PayToMobileState> {
  final _logger = Logger('PayToMobileCubit');

  final GetActiveAccountsSortedByAvailableBalance
      _getActiveAccountsSortedByAvailableBalance;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadCountriesUseCase _loadCountriesUseCase;
  final SubmitPayToMobileUseCase _submitPayToMobileUseCase;
  final SendOTPCodeForPayToMobileUseCase _sendOTPCodeForPayToMobileUseCase;
  final VerifyPayToMobileSecondFactorUseCase
      _verifyPayToMobileSecondFactorUseCase;
  final ResendPayToMobileSecondFactorUseCase
      _resendPayToMobileSecondFactorUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;

  /// Creates a new [PayToMobileCubit].
  PayToMobileCubit({
    required NewPayToMobile payToMobile,
    required GetActiveAccountsSortedByAvailableBalance
        getActiveAccountsSortedByAvailableBalance,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadCountriesUseCase loadCountriesUseCase,
    required SubmitPayToMobileUseCase submitPayToMobileUseCase,
    required SendOTPCodeForPayToMobileUseCase sendOTPCodeForPayToMobileUseCase,
    required VerifyPayToMobileSecondFactorUseCase
        verifyPayToMobileSecondFactorUseCase,
    required ResendPayToMobileSecondFactorUseCase
        resendPayToMobileSecondFactorUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
  })  : _getActiveAccountsSortedByAvailableBalance =
            getActiveAccountsSortedByAvailableBalance,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadCountriesUseCase = loadCountriesUseCase,
        _submitPayToMobileUseCase = submitPayToMobileUseCase,
        _sendOTPCodeForPayToMobileUseCase = sendOTPCodeForPayToMobileUseCase,
        _verifyPayToMobileSecondFactorUseCase =
            verifyPayToMobileSecondFactorUseCase,
        _resendPayToMobileSecondFactorUseCase =
            resendPayToMobileSecondFactorUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        super(PayToMobileState(
          payToMobile: payToMobile,
        ));

  /// Initializes the cubit with the needed data required for the pay to mobile
  /// flow.
  Future<void> initialize() async {
    await Future.wait([
      _loadAccounts(),
      _loadCurrencies(),
      _loadCountries(),
    ]);

    /// Initializes a new flow
    if (state.accounts.isNotEmpty && state.payToMobile.accountId == null) {
      final account = state.accounts.first;
      final currency = state.currencies.singleWhereOrNull(
        (currency) => currency.code == account.currency,
      );

      await onChanged(
        account: state.accounts.first,
        currency: currency,
      );
    }

    if (state.errors.isEmpty) {
      emit(
        state.copyWith(
          events: state.addEvent(
            PayToMobileEvent.initializeFlow,
          ),
        ),
      );
    }
  }

  /// Loads the accounts.
  Future<void> _loadAccounts() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(PayToMobileAction.accounts)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileAction.accounts,
          ),
          errors: state.removeErrorForAction(
            PayToMobileAction.accounts,
          ),
        ),
      );

      try {
        final accounts = await _getActiveAccountsSortedByAvailableBalance();

        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileAction.accounts,
            ),
            accounts: accounts,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileAction.accounts,
            ),
            errors: state.addErrorFromException(
              action: PayToMobileAction.accounts,
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
        state.errors.contains(PayToMobileAction.currencies)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileAction.currencies,
          ),
          errors: state.removeErrorForAction(
            PayToMobileAction.currencies,
          ),
        ),
      );

      try {
        final currencies = await _loadAllCurrenciesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileAction.currencies,
            ),
            currencies: currencies,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileAction.currencies,
            ),
            errors: state.addErrorFromException(
              action: PayToMobileAction.currencies,
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
        state.errors.contains(PayToMobileAction.countries)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileAction.countries,
          ),
          errors: state.removeErrorForAction(
            PayToMobileAction.countries,
          ),
        ),
      );

      try {
        final countries = await _loadCountriesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileAction.countries,
            ),
            countries: countries,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileAction.countries,
            ),
            errors: state.addErrorFromException(
              action: PayToMobileAction.countries,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Updates the transfer object.
  Future<void> onChanged({
    Account? account,
    String? dialCode,
    String? phoneNumber,
    double? amount,
    Currency? currency,
    String? transactionCode,
    bool? saveToShortcut,
    String? shortcutName,
  }) async {
    _clearValidationErrors(
      account: account,
      dialCode: dialCode,
      phoneNumber: phoneNumber,
      amount: amount,
      currency: currency,
      transactionCode: transactionCode,
      shortcutName: shortcutName,
    );

    if (account != null && currency == null) {
      currency = state.currencies.singleWhereOrNull(
        (currency) => currency.code == account.currency,
      );
    }

    if (saveToShortcut == false && state.payToMobile.saveToShortcut) {
      emit(
        state.copyWith(
          events: state.addEvent(
            PayToMobileEvent.clearShortcutName,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          events: state.removeEvent(
            PayToMobileEvent.clearShortcutName,
          ),
        ),
      );
    }

    emit(
      state.copyWith(
        payToMobile: state.payToMobile.copyWith(
          accountId: account?.id,
          dialCode: dialCode,
          phoneNumber: phoneNumber,
          amount: amount,
          currencyCode: currency?.code,
          transactionCode: transactionCode,
          saveToShortcut: saveToShortcut,
          shortcutName: shortcutName,
        ),
      ),
    );
  }

  /// Clears the validation errors based on the passed values.
  void _clearValidationErrors({
    Account? account,
    String? dialCode,
    String? phoneNumber,
    double? amount,
    Currency? currency,
    String? transactionCode,
    String? shortcutName,
  }) {
    final validationErrorCodesToClean = <PayToMobileValidationErrorCode>{};

    if (account != null && account.id != state.payToMobile.accountId) {
      validationErrorCodesToClean.add(
        PayToMobileValidationErrorCode.sourceAccountValidationError,
      );
    }

    if (dialCode != null && dialCode != state.payToMobile.dialCode) {
      validationErrorCodesToClean.add(
        PayToMobileValidationErrorCode.phoneNumberValidationError,
      );
    }

    if (phoneNumber != null && phoneNumber != state.payToMobile.phoneNumber) {
      validationErrorCodesToClean.add(
        PayToMobileValidationErrorCode.phoneNumberValidationError,
      );
    }

    if (amount != null && amount != state.payToMobile.amount) {
      validationErrorCodesToClean.addAll({
        PayToMobileValidationErrorCode.amountValidationError,
        PayToMobileValidationErrorCode.insufficientBalanceValidationError,
      });
    }

    if (transactionCode != null &&
        transactionCode != state.payToMobile.transactionCode) {
      validationErrorCodesToClean.add(
        PayToMobileValidationErrorCode.transactionCodeEmptyValidationError,
      );
    }

    if (transactionCode != null && transactionCode.length == 4) {
      validationErrorCodesToClean.add(
        PayToMobileValidationErrorCode.transactionCodeLengthValidationError,
      );
    }

    if (shortcutName != null &&
        shortcutName != state.payToMobile.shortcutName) {
      validationErrorCodesToClean.add(
        PayToMobileValidationErrorCode.shortcutNameValidationError,
      );
    }

    var cubitErrors = state.errors.toSet();
    for (final code in validationErrorCodesToClean) {
      cubitErrors.removeWhere((error) =>
          error is CubitValidationError && error.validationErrorCode == code);
    }

    emit(
      state.copyWith(
        errors: cubitErrors,
      ),
    );
  }

  /// Validates the pay to mobile transfer.
  Future<void> validate() async {
    emit(
      state.copyWith(
        errors: {},
        events: state.removeEvent(
          PayToMobileEvent.showConfirmationView,
        ),
      ),
    );

    final validationErrors = _validate();
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
          PayToMobileEvent.showConfirmationView,
        ),
      ),
    );
  }

  /// Validates the new transfer and returns the validation errors.
  Set<CubitValidationError<PayToMobileValidationErrorCode>> _validate() {
    final validationErrors =
        <CubitValidationError<PayToMobileValidationErrorCode>>{};

    final transfer = state.payToMobile;
    final account = state.accounts.singleWhereOrNull(
      (account) => account.id == transfer.accountId,
    );

    if (account == null) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode:
              PayToMobileValidationErrorCode.sourceAccountValidationError,
        ),
      );
    }

    if ((transfer.dialCode ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode:
              PayToMobileValidationErrorCode.phoneNumberValidationError,
        ),
      );
    }

    if ((transfer.phoneNumber ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode:
              PayToMobileValidationErrorCode.phoneNumberValidationError,
        ),
      );
    }

    if ((transfer.amount ?? 0.0) <= 0.0) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode:
              PayToMobileValidationErrorCode.amountValidationError,
        ),
      );
    }

    if ((transfer.amount ?? 0.0) > (account?.availableBalance ?? 0.0)) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode:
              PayToMobileValidationErrorCode.insufficientBalanceValidationError,
        ),
      );
    }

    final transactionCode = (transfer.transactionCode ?? '').trim();
    if (transactionCode.isEmpty) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode: PayToMobileValidationErrorCode
              .transactionCodeEmptyValidationError,
        ),
      );
    } else if (transactionCode.length < 4) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode: PayToMobileValidationErrorCode
              .transactionCodeLengthValidationError,
        ),
      );
    }

    if (transfer.saveToShortcut &&
        (transfer.shortcutName ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<PayToMobileValidationErrorCode>(
          validationErrorCode:
              PayToMobileValidationErrorCode.shortcutNameValidationError,
        ),
      );
    }

    return validationErrors;
  }

  /// Submits the pay to mobile transfer.
  Future<void> submit() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileAction.submit,
        ),
        errors: state.removeErrorForAction(
          PayToMobileAction.submit,
        ),
        events: state.removeEvents(
          {
            PayToMobileEvent.showResultView,
            PayToMobileEvent.openSecondFactor,
          },
        ),
      ),
    );

    try {
      final payToMobileResult = await _submitPayToMobileUseCase(
        newPayToMobile: state.payToMobile,
      );

      switch (payToMobileResult.status) {
        case PayToMobileStatus.completed:
        case PayToMobileStatus.pending:
        case PayToMobileStatus.bankPending:
          if (state.payToMobile.saveToShortcut) {
            await _createShortcut();
          }

          emit(
            state.copyWith(
              actions: state.removeAction(
                PayToMobileAction.submit,
              ),
              payToMobileResult: payToMobileResult,
              events: state.addEvent(
                PayToMobileEvent.showResultView,
              ),
            ),
          );
          break;

        case PayToMobileStatus.failed:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PayToMobileAction.submit,
              ),
              errors: state.addCustomCubitError(
                action: PayToMobileAction.submit,
                code: CubitErrorCode.transferFailed,
              ),
            ),
          );
          break;

        case PayToMobileStatus.pendingSecondFactor:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PayToMobileAction.submit,
              ),
              payToMobileResult: payToMobileResult,
              events: state.addEvent(
                PayToMobileEvent.openSecondFactor,
              ),
            ),
          );
          break;

        default:
          _logger.severe(
            'Unhandled pay to mobile status -> ${payToMobileResult.status}',
          );
          throw Exception(
            'Unhandled pay to mobile status -> ${payToMobileResult.status}',
          );
      }
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.submit,
          ),
          errors: state.addErrorFromException(
            action: PayToMobileAction.submit,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current [PayToMobile] retrievied on the
  /// [submit] method.
  Future<void> sendOTPCode() async {
    assert(state.payToMobileResult != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          PayToMobileAction.sendOTPCode,
        ),
        events: state.removeEvent(
          PayToMobileEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final payToMobileResult = await _sendOTPCodeForPayToMobileUseCase(
        requestId: state.payToMobileResult?.requestId ?? '',
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.sendOTPCode,
          ),
          payToMobileResult: payToMobileResult,
          events: state.addEvent(
            PayToMobileEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: PayToMobileAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the [PayToMobile] retrievied on the
  /// [submit] method.
  Future<void> verifySecondFactor({
    String? otpCode,
    String? ocraClientResponse,
  }) async {
    assert(
      otpCode != null || ocraClientResponse != null,
      'An OTP code or OCRA client response must be provided in order for '
      'verifying the second factor',
    );

    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileAction.verifySecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final payToMobileResult = await _verifyPayToMobileSecondFactorUseCase(
        requestId: state.payToMobileResult?.requestId ?? '',
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
      );

      if (state.payToMobile.saveToShortcut) {
        await _createShortcut();
      }

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          payToMobileResult: payToMobileResult,
          events: state.addEvent(
            PayToMobileEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: PayToMobileAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resends the second factor for the [PayToMobile] retrievied on
  /// the [submit] method.
  Future<void> resendSecondFactor() async {
    assert(state.payToMobileResult != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileAction.resendSecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final payToMobileResult = await _resendPayToMobileSecondFactorUseCase(
        payToMobile: state.payToMobileResult!,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          payToMobileResult: payToMobileResult,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: PayToMobileAction.resendSecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Creates the shortcut (if enabled).
  Future<void> _createShortcut() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileAction.shortcut,
        ),
        errors: state.removeErrorForAction(
          PayToMobileAction.shortcut,
        ),
      ),
    );

    try {
      await _createShortcutUseCase(
        shortcut: NewShortcut(
          name: state.payToMobile.shortcutName!,
          type: ShortcutType.payToMobile,
          payload: state.payToMobile,
        ),
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.shortcut,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileAction.shortcut,
          ),
          errors: state.addErrorFromException(
            action: PayToMobileAction.shortcut,
            exception: e,
          ),
        ),
      );
    }
  }
}
