import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

/// A Cubit that handles the state for the beneficiary transfer flow.
class BeneficiaryTransferCubit extends Cubit<BeneficiaryTransferState> {
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;
  final GetSourceAccountsForBeneficiaryTransferUseCase
      _getSourceAccountsForBeneficiaryTransferUseCase;
  final GetDestinationBeneficiariesForBeneficiariesTransferUseCase
      _getDestinationBeneficiariesForBeneficiariesTransferUseCase;
  final LoadCountriesUseCase _loadCountriesUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadMessagesByModuleUseCase _loadMessagesByModuleUseCase;
  final LoadBanksByCountryCodeUseCase _loadBanksByCountryCodeUseCase;
  final ValidateIBANUseCase _validateIBANUseCase;
  final EvaluateTransferUseCase _evaluateTransferUseCase;
  final SubmitTransferUseCase _submitTransferUseCase;
  final VerifyTransferSecondFactorUseCase _verifyTransferSecondFactorUseCase;
  final ResendTransferSecondFactorUseCase _resendTransferSecondFactorUseCase;

  /// Creates a new [BeneficiaryTransferCubit].
  BeneficiaryTransferCubit({
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
    required BeneficiaryTransfer transfer,
    required GetSourceAccountsForBeneficiaryTransferUseCase
        getSourceAccountsForBeneficiaryTransferUseCase,
    required GetDestinationBeneficiariesForBeneficiariesTransferUseCase
        getDestinationBeneficiariesForBeneficiariesTransferUseCase,
    required LoadCountriesUseCase loadCountriesUseCase,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadMessagesByModuleUseCase loadMessagesByModuleUseCase,
    required LoadBanksByCountryCodeUseCase loadBanksByCountryCodeUseCase,
    required ValidateIBANUseCase validateIBANUseCase,
    required EvaluateTransferUseCase evaluateTransferUseCase,
    required SubmitTransferUseCase submitTransferUseCase,
    required VerifyTransferSecondFactorUseCase
        verifyTransferSecondFactorUseCase,
    required ResendTransferSecondFactorUseCase
        resendTransferSecondFactorUseCase,
  })  : _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        _getSourceAccountsForBeneficiaryTransferUseCase =
            getSourceAccountsForBeneficiaryTransferUseCase,
        _getDestinationBeneficiariesForBeneficiariesTransferUseCase =
            getDestinationBeneficiariesForBeneficiariesTransferUseCase,
        _loadCountriesUseCase = loadCountriesUseCase,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadMessagesByModuleUseCase = loadMessagesByModuleUseCase,
        _loadBanksByCountryCodeUseCase = loadBanksByCountryCodeUseCase,
        _validateIBANUseCase = validateIBANUseCase,
        _evaluateTransferUseCase = evaluateTransferUseCase,
        _submitTransferUseCase = submitTransferUseCase,
        _verifyTransferSecondFactorUseCase = verifyTransferSecondFactorUseCase,
        _resendTransferSecondFactorUseCase = resendTransferSecondFactorUseCase,
        super(
          BeneficiaryTransferState(
            transfer: transfer,
          ),
        );

  /// Initializes the [BeneficiaryTransferCubit].
  Future<void> initialize() async {
    await Future.wait([
      _loadBeneficiarySettings(),
      _loadAccounts(),
      _loadCurrencies(),
      _loadCountries(),
      _loadBeneficiaries(),
      _loadReasons(),
    ]);

    onChanged();
  }

  /// Returns an action list that includes the passed action.
  Set<BeneficiaryTransferAction> _addAction(
    BeneficiaryTransferAction action,
  ) =>
      state.actions.union({action});

  /// Returns an error list that includes the passed action and error status.
  Set<BeneficiaryTransferError> _addError({
    required BeneficiaryTransferAction action,
    required BeneficiaryTransferErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        BeneficiaryTransferError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Returns an action list containing all the actions but the one that
  /// coindides with the passed action.
  Set<BeneficiaryTransferAction> _removeAction(
    BeneficiaryTransferAction action,
  ) =>
      state.actions.difference({action});

  /// Returns an error list containing all the errors but the one that
  /// coincides with the passed action.
  Set<BeneficiaryTransferError> _removeError(
    BeneficiaryTransferAction action,
  ) =>
      state.errors.where((error) => error.action != action).toSet();

  /// Loads the beneficiary settings.
  Future<void> _loadBeneficiarySettings() async {
    if (state.beneficiarySettings.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.beneficiarySettings)) {
      emit(
        state.copyWith(
          actions: _addAction(BeneficiaryTransferAction.beneficiarySettings),
          errors: _removeError(BeneficiaryTransferAction.beneficiarySettings),
        ),
      );

      try {
        final beneficiarySettings = await _loadGlobalSettingsUseCase(
          codes: ['benef_iban_allowed_characters'],
        );

        emit(
          state.copyWith(
            actions:
                _removeAction(BeneficiaryTransferAction.beneficiarySettings),
            beneficiarySettings: beneficiarySettings,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions:
                _removeAction(BeneficiaryTransferAction.beneficiarySettings),
            errors: _addError(
              action: BeneficiaryTransferAction.beneficiarySettings,
              errorStatus: e is NetException
                  ? BeneficiaryTransferErrorStatus.network
                  : BeneficiaryTransferErrorStatus.generic,
            ),
          ),
        );
      }
    }
  }

  /// Loads all the currencies.
  Future<void> _loadCurrencies() async {
    if (state.currencies.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.currencies)) {
      emit(
        state.copyWith(
          actions: _addAction(BeneficiaryTransferAction.currencies),
          errors: _removeError(BeneficiaryTransferAction.currencies),
        ),
      );

      try {
        final currencies = await _loadAllCurrenciesUseCase();

        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.currencies),
            currencies: currencies,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.currencies),
            errors: _addError(
              action: BeneficiaryTransferAction.currencies,
              errorStatus: e is NetException
                  ? BeneficiaryTransferErrorStatus.network
                  : BeneficiaryTransferErrorStatus.generic,
            ),
          ),
        );
      }
    }
  }

  /// Loads all the countries.
  Future<void> _loadCountries() async {
    if (state.countries.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.countries)) {
      emit(
        state.copyWith(
          actions: _addAction(BeneficiaryTransferAction.countries),
          errors: _removeError(BeneficiaryTransferAction.countries),
        ),
      );

      try {
        final countries = await _loadCountriesUseCase();

        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.countries),
            countries: countries,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.countries),
            errors: _addError(
              action: BeneficiaryTransferAction.countries,
              errorStatus: e is NetException
                  ? BeneficiaryTransferErrorStatus.network
                  : BeneficiaryTransferErrorStatus.generic,
            ),
          ),
        );
      }
    }
  }

  /// Loads the accounts.
  Future<void> _loadAccounts() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.accounts)) {
      emit(
        state.copyWith(
          actions: _addAction(BeneficiaryTransferAction.accounts),
          errors: _removeError(BeneficiaryTransferAction.accounts),
        ),
      );

      try {
        final accounts =
            await _getSourceAccountsForBeneficiaryTransferUseCase();

        if (accounts.isNotEmpty) {
          onChanged(
            source: accounts
                .sortedBy<num>((element) => element.availableBalance ?? 0.0)
                .reversed
                .first,
          );
        }

        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.accounts),
            accounts: accounts,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.accounts),
            errors: _addError(
              action: BeneficiaryTransferAction.accounts,
              errorStatus: e is NetException
                  ? BeneficiaryTransferErrorStatus.network
                  : BeneficiaryTransferErrorStatus.generic,
            ),
          ),
        );
      }
    }
  }

  /// Loads the beneficiaries.
  Future<void> _loadBeneficiaries() async {
    if (state.beneficiaries.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.beneficiaries)) {
      emit(
        state.copyWith(
          actions: _addAction(BeneficiaryTransferAction.beneficiaries),
          errors: _removeError(BeneficiaryTransferAction.beneficiaries),
        ),
      );

      try {
        final beneficiaries =
            await _getDestinationBeneficiariesForBeneficiariesTransferUseCase();

        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.beneficiaries),
            beneficiaries: beneficiaries,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.beneficiaries),
            errors: _addError(
              action: BeneficiaryTransferAction.beneficiaries,
              errorStatus: e is NetException
                  ? BeneficiaryTransferErrorStatus.network
                  : BeneficiaryTransferErrorStatus.generic,
            ),
          ),
        );
      }
    }
  }

  /// Loads the reasons.
  Future<void> _loadReasons() async {
    if (state.reasons.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.reasons)) {
      emit(
        state.copyWith(
          actions: _addAction(BeneficiaryTransferAction.reasons),
          errors: _removeError(BeneficiaryTransferAction.reasons),
        ),
      );

      try {
        final reasons = await _loadMessagesByModuleUseCase(
          module: state.transfer.type == TransferType.international
              ? 'transfer_reasons_international'
              : 'transfer_reasons',
        );

        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.reasons),
            reasons: reasons,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.reasons),
            errors: _addError(
              action: BeneficiaryTransferAction.reasons,
              errorStatus: e is NetException
                  ? BeneficiaryTransferErrorStatus.network
                  : BeneficiaryTransferErrorStatus.generic,
            ),
          ),
        );
      }
    }
  }

  /// Loads the banks for the passed country code.
  Future<void> loadBanks({
    required String countryCode,
  }) async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.banks),
        errors: _removeError(BeneficiaryTransferAction.banks),
        banks: {},
      ),
    );

    try {
      final banks = await _loadBanksByCountryCodeUseCase(
        countryCode: countryCode,
      );

      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.banks),
          banks: banks,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.banks),
          errors: _addError(
            action: BeneficiaryTransferAction.banks,
            errorStatus: e is NetException
                ? BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
          ),
        ),
      );
    }
  }

  /// Updates the transfer object.
  Future<void> onChanged({
    TransferType? type,
    Account? source,
    Beneficiary? destination,
    double? amount,
    Currency? currency,
    Message? reason,
    DestinationBeneficiaryType? beneficiaryType,
    NewBeneficiary? newBeneficiary,
  }) async {
    final sourceCurrency = state.currencies.firstWhereOrNull(
      (currency) => currency.code == state.transfer.source?.account?.currency,
    );

    if (newBeneficiary?.country != null &&
        newBeneficiary?.country != state.transfer.newBeneficiary?.country) {
      loadBanks(countryCode: newBeneficiary!.country!.countryCode ?? '');
    }

    emit(
      state.copyWith(
        transfer: state.transfer.copyWith(
          type: type,
          source: source == null
              ? null
              : NewTransferSource(
                  account: source,
                ),
          destination: destination == null
              ? null
              : NewTransferDestination(
                  beneficiary: destination,
                ),
          amount: amount,
          currency: sourceCurrency,
          reason: reason,
          beneficiaryType: beneficiaryType,
          newBeneficiary: newBeneficiary,
        ),
      ),
    );
  }

  /// Evaluates the transfer.
  Future<void> evaluate() async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.evaluate),
        errors: {},
        evaluation: TransferEvaluation(),
      ),
    );

    final beneficiaryType = state.transfer.beneficiaryType;
    final shouldValidateIBAN =
        beneficiaryType == DestinationBeneficiaryType.newBeneficiary &&
            state.transfer.newBeneficiary?.sortCode == null;
    if (shouldValidateIBAN) {
      final isValid = _validateIBANUseCase(
        iban: state.transfer.newBeneficiary?.ibanOrAccountNO ?? '',
        allowedCharacters: state.beneficiarySettings
            .singleWhereOrNull(
                (element) => element.code == 'benef_iban_allowed_characters')
            ?.value
            ?.split(''),
      );

      if (!isValid) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.evaluate),
            errors: _addError(
              action: BeneficiaryTransferAction.evaluate,
              errorStatus: BeneficiaryTransferErrorStatus.invalidIBAN,
            ),
          ),
        );

        return;
      }
    }

    try {
      final evaluation = await _evaluateTransferUseCase(
        transfer: state.transfer,
      );

      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.evaluate),
          evaluation: evaluation,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.evaluate),
          errors: _addError(
            action: BeneficiaryTransferAction.evaluate,
            errorStatus: e is NetException
                ? BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Submits the transfer.
  Future<void> submit() async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.submit),
        errors: _removeError(BeneficiaryTransferAction.submit),
      ),
    );

    try {
      final transferResult = await _submitTransferUseCase(
        transfer: state.transfer,
      );

      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.submit),
          transferResult: transferResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.submit),
          errors: _addError(
            action: BeneficiaryTransferAction.submit,
            errorStatus: e is NetException
                ? e.code == 'insufficient_balance'
                    ? BeneficiaryTransferErrorStatus.insufficientBalance
                    : BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the transfer retrievied on the [submit]
  /// method.
  Future<void> verifySecondFactor({
    required String otpValue,
  }) async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.verifySecondFactor),
        errors: {},
      ),
    );

    try {
      final transferResult = await _verifyTransferSecondFactorUseCase(
        transferId: state.transferResult?.id ?? 0,
        otpValue: otpValue,
        secondFactorType:
            state.transferResult?.secondFactorType ?? SecondFactorType.otp,
      );

      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.verifySecondFactor),
          transferResult: transferResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.verifySecondFactor),
          errors: _addError(
            action: BeneficiaryTransferAction.verifySecondFactor,
            errorStatus: e is NetException
                ? BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
            code: e is NetException
                ? e.statusCode == null
                    ? 'connectivity_error'
                    : e.code
                : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Resends the second factor for the transfer retrievied on the [submit]
  /// method.
  Future<void> resendSecondFactor() async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.resendSecondFactor),
        errors: {},
      ),
    );

    try {
      final transferResult = await _resendTransferSecondFactorUseCase(
        transfer: state.transfer,
      );

      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.resendSecondFactor),
          transferResult: transferResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.resendSecondFactor),
          errors: _addError(
            action: BeneficiaryTransferAction.resendSecondFactor,
            errorStatus: e is NetException
                ? BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
            code: e is NetException
                ? e.statusCode == null
                    ? 'connectivity_error'
                    : e.code
                : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }
}
