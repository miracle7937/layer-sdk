import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';
import '../../../utils.dart';

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
  final CreateShortcutUseCase _createShortcutUseCase;

  /// Creates a new [BeneficiaryTransferCubit].
  ///
  /// The `editMode` param is defined to update/edit the selected transfer
  /// Case `true` the API will `PATCH` the transfer
  BeneficiaryTransferCubit({
    bool editMode = false,
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
    required CreateShortcutUseCase createShortcutUseCase,
    int banksPaginationLimit = 20,
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
        _createShortcutUseCase = createShortcutUseCase,
        super(
          BeneficiaryTransferState(
            transfer: transfer,
            banksPagination: Pagination(
              limit: banksPaginationLimit,
            ),
            editMode: editMode,
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
              code: e is NetException
                  ? e.statusCode == null
                      ? 'connectivity_error'
                      : e.code
                  : null,
              message: e is NetException ? e.message : null,
            ),
          ),
        );
      }
    }
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
              code: e is NetException
                  ? e.statusCode == null
                      ? 'connectivity_error'
                      : e.code
                  : null,
              message: e is NetException ? e.message : null,
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
              code: e is NetException
                  ? e.statusCode == null
                      ? 'connectivity_error'
                      : e.code
                  : null,
              message: e is NetException ? e.message : null,
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
              code: e is NetException
                  ? e.statusCode == null
                      ? 'connectivity_error'
                      : e.code
                  : null,
              message: e is NetException ? e.message : null,
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
              code: e is NetException
                  ? e.statusCode == null
                      ? 'connectivity_error'
                      : e.code
                  : null,
              message: e is NetException ? e.message : null,
            ),
          ),
        );
      }
    }
  }

  /// Loads the banks for the passed country code.
  Future<void> loadBanks({
    bool loadMore = false,
  }) async {
    final countryCode = state.transfer.newBeneficiary?.country?.countryCode;
    if (countryCode == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.banks),
        errors: _removeError(BeneficiaryTransferAction.banks),
        banks: loadMore ? state.banks : {},
      ),
    );

    try {
      final newPage = state.banksPagination.paginate(loadMore: loadMore);

      final resultList = await _loadBanksByCountryCodeUseCase(
        countryCode: countryCode,
        limit: newPage.limit,
        offset: newPage.offset,
        query: state.bankQuery,
      );

      final banks = newPage.firstPage
          ? resultList
          : [
              ...state.banks,
              ...resultList,
            ];

      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.banks),
          banks: banks,
          banksPagination: newPage.refreshCanLoadMore(
            loadedCount: resultList.length,
          ),
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
            code: e is NetException
                ? e.statusCode == null
                    ? 'connectivity_error'
                    : e.code
                : null,
            message: e is NetException ? e.message : null,
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
    String? reason,
    DestinationBeneficiaryType? beneficiaryType,
    NewBeneficiary? newBeneficiary,
    bool? saveToShortcut,
    String? shortcutName,
    String? note,
    ScheduleDetails? scheduleDetails,
    String? bankQuery,
  }) async {
    final sourceCurrency = state.currencies.firstWhereOrNull(
      (currency) => currency.code == state.transfer.source?.account?.currency,
    );

    final currentCountry = state.transfer.newBeneficiary?.country;

    if (scheduleDetails != null) {
      emit(
        state.copyWith(
          errors: state.errors
              .where((error) =>
                  error.errorStatus !=
                  BeneficiaryTransferErrorStatus.scheduleDetailsValidationError)
              .toSet(),
        ),
      );
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
          saveToShortcut: saveToShortcut,
          shortcutName: shortcutName,
          note: note,
          scheduleDetails: scheduleDetails,
        ),
        bankQuery: bankQuery,
      ),
    );

    if (bankQuery != null ||
        (newBeneficiary?.country != null &&
            newBeneficiary?.country != currentCountry)) {
      loadBanks();
    }
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

    final validationErrors = _validateTransfer();

    if (validationErrors.isNotEmpty) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.evaluate),
          errors: validationErrors,
        ),
      );

      return;
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
            message: e is NetException ? e.message : null,
          ),
        ),
      );
    }
  }

  /// Validates the new transfer and returns the validation errors.
  Set<BeneficiaryTransferError> _validateTransfer() {
    final validationErrors = <BeneficiaryTransferError>{};

    final transfer = state.transfer;
    final beneficiaryType = transfer.beneficiaryType;

    if (transfer.source?.account == null) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus:
            BeneficiaryTransferErrorStatus.sourceAccountValidationError,
      ));
    }

    if ((transfer.amount ?? 0.0) <= 0.0) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.amountValidationError,
      ));
    }

    if (transfer.saveToShortcut &&
        (transfer.shortcutName ?? '').toString().isEmpty) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.shortcutNameValidationError,
      ));
    }

    if (transfer.scheduleDetails.recurrence != Recurrence.none &&
        transfer.scheduleDetails.startDate == null) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus:
            BeneficiaryTransferErrorStatus.scheduleDetailsValidationError,
      ));
    }

    if (beneficiaryType == DestinationBeneficiaryType.newBeneficiary) {
      validationErrors.addAll(_validateNewBeneficiary());
    } else if (transfer.destination?.beneficiary == null) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus:
            BeneficiaryTransferErrorStatus.selectedBeneficiaryValidationError,
      ));
    }

    return validationErrors;
  }

  /// Validates the new beneficiary and retruns a list of validation errors.
  Set<BeneficiaryTransferError> _validateNewBeneficiary() {
    final validationErrors = <BeneficiaryTransferError>{};

    final newBeneficiary = state.transfer.newBeneficiary;

    if ((newBeneficiary?.firstName ?? '').trim().isEmpty) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.firstNameValidationError,
      ));
    }

    if ((newBeneficiary?.lastName ?? '').isEmpty) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.lastNameValidationError,
      ));
    }

    if (newBeneficiary?.country == null) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.countryValidationError,
      ));
    }

    if (newBeneficiary?.currency == null) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.currencyValidationError,
      ));
    }

    if ((newBeneficiary?.ibanOrAccountNO ?? '').trim().isEmpty) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus:
            BeneficiaryTransferErrorStatus.ibanOrAccountValidationError,
      ));
    }

    if ((newBeneficiary?.routingCode ?? '').trim().isEmpty &&
        (newBeneficiary?.routingCodeIsRequired ?? false)) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.routingCodeValidationError,
      ));
    }

    if (newBeneficiary?.bank == null) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.bankValidationError,
      ));
    }

    if ((newBeneficiary?.shouldSave ?? false) &&
        (newBeneficiary?.nickname ?? '').trim().isEmpty) {
      validationErrors.add(BeneficiaryTransferError(
        action: BeneficiaryTransferAction.evaluate,
        errorStatus: BeneficiaryTransferErrorStatus.nicknameValidationError,
      ));
    }

    final shouldValidateIBAN =
        !(newBeneficiary?.routingCodeIsRequired ?? false) &&
            (newBeneficiary?.ibanOrAccountNO?.isNotEmpty ?? false);

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
        validationErrors.add(BeneficiaryTransferError(
          action: BeneficiaryTransferAction.evaluate,
          errorStatus: BeneficiaryTransferErrorStatus.invalidIBAN,
        ));
      }
    }

    return validationErrors;
  }

  /// Submits the transfer.
  Future<void> submit() async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.submit),
        errors: _removeError(BeneficiaryTransferAction.submit),
      ),
    );

    if (state.transfer.saveToShortcut) {
      await _createShortcut();

      if (state.errors
          .where((error) => error.action == BeneficiaryTransferAction.shortcut)
          .isNotEmpty) {
        emit(
          state.copyWith(
            actions: _removeAction(BeneficiaryTransferAction.submit),
          ),
        );

        return;
      }
    }

    try {
      final transferResult = await _submitTransferUseCase(
        transfer: state.transfer,
        editMode: state.editMode,
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
            code: e is NetException
                ? e.statusCode == null
                    ? 'connectivity_error'
                    : e.code
                : null,
            message: e is NetException ? e.message : null,
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
                ? e.code == 'incorrect_value'
                    ? BeneficiaryTransferErrorStatus.incorrectOTPCode
                    : BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
            code: e is NetException
                ? e.statusCode == null
                    ? 'connectivity_error'
                    : e.code
                : null,
            message: e is NetException ? e.message : null,
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
            message: e is NetException ? e.message : null,
          ),
        ),
      );
    }
  }

  /// Creates the shortcut (if enabled) once the transfer has succeded.
  Future<void> _createShortcut() async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryTransferAction.shortcut),
        errors: _removeError(BeneficiaryTransferAction.shortcut),
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
          actions: _removeAction(BeneficiaryTransferAction.shortcut),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryTransferAction.shortcut),
          errors: _addError(
            action: BeneficiaryTransferAction.shortcut,
            errorStatus: e is NetException
                ? BeneficiaryTransferErrorStatus.network
                : BeneficiaryTransferErrorStatus.generic,
            code: e is NetException
                ? e.statusCode == null
                    ? 'connectivity_error'
                    : e.code
                : null,
            message: e is NetException ? e.message : null,
          ),
        ),
      );
    }
  }
}
