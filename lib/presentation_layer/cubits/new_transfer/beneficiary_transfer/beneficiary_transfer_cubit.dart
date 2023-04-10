import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../../domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';
import '../../../utils.dart';

/// A Cubit that handles the state for the beneficiary transfer flow.
class BeneficiaryTransferCubit extends Cubit<BeneficiaryTransferState> {
  final _logger = Logger('BeneficiaryTransferCubit');

  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;
  final GetActiveAccountsSortedByAvailableBalance
      _getActiveAccountsSortedByAvailableBalance;
  final GetDestinationBeneficiariesForBeneficiariesTransferUseCase
      _getDestinationBeneficiariesForBeneficiariesTransferUseCase;
  final LoadCountriesUseCase _loadCountriesUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadMessagesByModuleUseCase _loadMessagesByModuleUseCase;
  final LoadBanksByCountryCodeUseCase _loadBanksByCountryCodeUseCase;
  final ValidateIBANUseCase _validateIBANUseCase;
  final EvaluateTransferUseCase _evaluateTransferUseCase;
  final SendOTPCodeForTransferUseCase _sendOTPCodeForTransferUseCase;
  final SubmitTransferUseCase _submitTransferUseCase;
  final VerifyTransferSecondFactorUseCase _verifyTransferSecondFactorUseCase;
  final ResendTransferSecondFactorUseCase _resendTransferSecondFactorUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;
  final GenerateDeviceUIDUseCase _generateDeviceUIDUseCase;

  /// Creates a new [BeneficiaryTransferCubit].
  ///
  /// The `editMode` param is defined to update/edit the selected transfer
  /// Case `true` the API will `PATCH` the transfer
  BeneficiaryTransferCubit({
    bool editMode = false,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
    required BeneficiaryTransfer transfer,
    required GetActiveAccountsSortedByAvailableBalance
        getActiveAccountsSortedByAvailableBalance,
    required GetDestinationBeneficiariesForBeneficiariesTransferUseCase
        getDestinationBeneficiariesForBeneficiariesTransferUseCase,
    required LoadCountriesUseCase loadCountriesUseCase,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadMessagesByModuleUseCase loadMessagesByModuleUseCase,
    required LoadBanksByCountryCodeUseCase loadBanksByCountryCodeUseCase,
    required ValidateIBANUseCase validateIBANUseCase,
    required EvaluateTransferUseCase evaluateTransferUseCase,
    required SendOTPCodeForTransferUseCase sendOTPCodeForTransferUseCase,
    required SubmitTransferUseCase submitTransferUseCase,
    required VerifyTransferSecondFactorUseCase
        verifyTransferSecondFactorUseCase,
    required ResendTransferSecondFactorUseCase
        resendTransferSecondFactorUseCase,
    required GenerateDeviceUIDUseCase generateDeviceUIDUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    int banksPaginationLimit = 20,
  })  : _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        _getActiveAccountsSortedByAvailableBalance =
            getActiveAccountsSortedByAvailableBalance,
        _getDestinationBeneficiariesForBeneficiariesTransferUseCase =
            getDestinationBeneficiariesForBeneficiariesTransferUseCase,
        _loadCountriesUseCase = loadCountriesUseCase,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadMessagesByModuleUseCase = loadMessagesByModuleUseCase,
        _loadBanksByCountryCodeUseCase = loadBanksByCountryCodeUseCase,
        _validateIBANUseCase = validateIBANUseCase,
        _evaluateTransferUseCase = evaluateTransferUseCase,
        _sendOTPCodeForTransferUseCase = sendOTPCodeForTransferUseCase,
        _submitTransferUseCase = submitTransferUseCase,
        _verifyTransferSecondFactorUseCase = verifyTransferSecondFactorUseCase,
        _resendTransferSecondFactorUseCase = resendTransferSecondFactorUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        _generateDeviceUIDUseCase = generateDeviceUIDUseCase,
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

  /// Loads the beneficiary settings.
  Future<void> _loadBeneficiarySettings() async {
    if (state.beneficiarySettings.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.beneficiarySettings)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            BeneficiaryTransferAction.beneficiarySettings,
          ),
          errors: state.removeErrorForAction(
            BeneficiaryTransferAction.beneficiarySettings,
          ),
        ),
      );

      try {
        final beneficiarySettings = await _loadGlobalSettingsUseCase(
          codes: ['benef_iban_allowed_characters'],
        );

        emit(
          state.copyWith(
            actions: state
                .removeAction(BeneficiaryTransferAction.beneficiarySettings),
            beneficiarySettings: beneficiarySettings,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state
                .removeAction(BeneficiaryTransferAction.beneficiarySettings),
            errors: state.addErrorFromException(
              action: BeneficiaryTransferAction.beneficiarySettings,
              exception: e,
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
          actions: state.addAction(
            BeneficiaryTransferAction.accounts,
          ),
          errors: state.removeErrorForAction(
            BeneficiaryTransferAction.accounts,
          ),
        ),
      );

      try {
        final accounts = await _getActiveAccountsSortedByAvailableBalance();

        if (accounts.isNotEmpty) {
          onChanged(
            source: accounts.first,
          );
        }

        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.accounts,
            ),
            accounts: accounts,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.accounts,
            ),
            errors: state.addErrorFromException(
              action: BeneficiaryTransferAction.accounts,
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
        state.errors.contains(BeneficiaryTransferAction.currencies)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            BeneficiaryTransferAction.currencies,
          ),
          errors: state.removeErrorForAction(
            BeneficiaryTransferAction.currencies,
          ),
        ),
      );

      try {
        final currencies = await _loadAllCurrenciesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.currencies,
            ),
            currencies: currencies,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.currencies,
            ),
            errors: state.addErrorFromException(
              action: BeneficiaryTransferAction.currencies,
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
        state.errors.contains(BeneficiaryTransferAction.countries)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            BeneficiaryTransferAction.countries,
          ),
          errors: state.removeErrorForAction(
            BeneficiaryTransferAction.countries,
          ),
        ),
      );

      try {
        final countries = await _loadCountriesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.countries,
            ),
            countries: countries,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.countries,
            ),
            errors: state.addErrorFromException(
              action: BeneficiaryTransferAction.countries,
              exception: e,
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
          actions: state.addAction(
            BeneficiaryTransferAction.beneficiaries,
          ),
          errors: state.removeErrorForAction(
            BeneficiaryTransferAction.beneficiaries,
          ),
        ),
      );

      try {
        final beneficiaries =
            await _getDestinationBeneficiariesForBeneficiariesTransferUseCase();

        emit(
          state.copyWith(
            actions:
                state.removeAction(BeneficiaryTransferAction.beneficiaries),
            beneficiaries: beneficiaries,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.beneficiaries,
            ),
            errors: state.addErrorFromException(
              action: BeneficiaryTransferAction.beneficiaries,
              exception: e,
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
          actions: state.addAction(
            BeneficiaryTransferAction.reasons,
          ),
          errors: state.removeErrorForAction(
            BeneficiaryTransferAction.reasons,
          ),
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
            actions: state.removeAction(
              BeneficiaryTransferAction.reasons,
            ),
            reasons: reasons,
          ),
        );
      } on Exception catch (e, st) {
        logException(e, st);
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.reasons,
            ),
            errors: state.addErrorFromException(
              action: BeneficiaryTransferAction.reasons,
              exception: e,
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
        actions: state.addAction(
          BeneficiaryTransferAction.banks,
        ),
        errors: state.removeErrorForAction(
          BeneficiaryTransferAction.banks,
        ),
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
          actions: state.removeAction(
            BeneficiaryTransferAction.banks,
          ),
          banks: banks,
          banksPagination: newPage.refreshCanLoadMore(
            loadedCount: resultList.length,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.banks,
          ),
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.banks,
            exception: e,
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
    String? reason,
    DestinationBeneficiaryType? beneficiaryType,
    NewBeneficiary? newBeneficiary,
    bool? saveToShortcut,
    String? shortcutName,
    String? note,
    ScheduleDetails? scheduleDetails,
    String? bankQuery,
  }) async {
    _clearValidationErrors(
      source: source,
      destination: destination,
      amount: amount,
      newBeneficiary: newBeneficiary,
      shortcutName: shortcutName,
      scheduleDetails: scheduleDetails,
    );

    final sourceCurrency = state.currencies.firstWhereOrNull(
      (currency) => currency.code == state.transfer.source?.account?.currency,
    );

    final currentCountry = state.transfer.newBeneficiary?.country;

    if (scheduleDetails != null) {
      emit(
        state.copyWith(
          errors: state.removeValidationError(
            BeneficiaryTransferValidationErrorCode
                .scheduleDetailsValidationError,
          ),
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

  /// Clears the validation errors based on the passed values.
  void _clearValidationErrors({
    Account? source,
    Beneficiary? destination,
    double? amount,
    NewBeneficiary? newBeneficiary,
    String? shortcutName,
    ScheduleDetails? scheduleDetails,
  }) {
    final validationErrorCodesToClean =
        <BeneficiaryTransferValidationErrorCode>{};

    if (source != null && source != state.transfer.source?.account) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.sourceAccountValidationError,
      );
    }

    if (destination != null &&
        destination != state.transfer.destination?.beneficiary) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode
            .selectedBeneficiaryValidationError,
      );
    }

    if (newBeneficiary?.firstName != null &&
        newBeneficiary?.firstName != state.transfer.newBeneficiary?.firstName) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.firstNameValidationError,
      );
    }

    if (newBeneficiary?.lastName != null &&
        newBeneficiary?.lastName != state.transfer.newBeneficiary?.lastName) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.lastNameValidationError,
      );
    }

    if (newBeneficiary?.country != null &&
        newBeneficiary?.country != state.transfer.newBeneficiary?.country) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.countryValidationError,
      );
    }

    if (newBeneficiary?.currency != null &&
        newBeneficiary?.currency != state.transfer.newBeneficiary?.currency) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.currencyValidationError,
      );
    }

    if (newBeneficiary?.ibanOrAccountNO != null &&
        newBeneficiary?.ibanOrAccountNO !=
            state.transfer.newBeneficiary?.ibanOrAccountNO) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.ibanOrAccountValidationError,
      );
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
            ?.value,
      );

      if (isValid) {
        validationErrorCodesToClean.add(
          BeneficiaryTransferValidationErrorCode.invalidIBAN,
        );
      }
    }

    if (newBeneficiary?.routingCodeIsRequired != null &&
        newBeneficiary?.routingCode !=
            state.transfer.newBeneficiary?.routingCode) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.routingCodeValidationError,
      );
    }

    if (newBeneficiary?.bank != null &&
        newBeneficiary?.bank != state.transfer.newBeneficiary?.bank) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.bankValidationError,
      );
    }

    if (amount != null && amount != state.transfer.amount) {
      validationErrorCodesToClean.addAll({
        BeneficiaryTransferValidationErrorCode.amountValidationError,
        BeneficiaryTransferValidationErrorCode
            .insufficientBalanceValidationError,
      });
    }

    if (newBeneficiary?.nickname != null &&
        newBeneficiary?.nickname != state.transfer.newBeneficiary?.nickname) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.nicknameValidationError,
      );
    }

    if (shortcutName != null && shortcutName != state.transfer.shortcutName) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.shortcutNameValidationError,
      );
    }

    if (scheduleDetails != null &&
        scheduleDetails != state.transfer.scheduleDetails) {
      validationErrorCodesToClean.add(
        BeneficiaryTransferValidationErrorCode.scheduleDetailsValidationError,
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

  /// Evaluates the transfer.
  Future<void> evaluate() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          BeneficiaryTransferAction.evaluate,
        ),
        errors: {},
        events: state.removeEvent(
          BeneficiaryTransferEvent.showConfirmationView,
        ),
        evaluation: TransferEvaluation(),
      ),
    );

    final validationErrors = _validateTransfer();
    if (validationErrors.isNotEmpty) {
      emit(
        state.copyWith(
          actions: state.removeAction(BeneficiaryTransferAction.evaluate),
          errors: state.addValidationErrors(validationErrors: validationErrors),
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
          actions: state.removeAction(
            BeneficiaryTransferAction.evaluate,
          ),
          events: state.addEvent(
            BeneficiaryTransferEvent.showConfirmationView,
          ),
          evaluation: evaluation,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.evaluate,
          ),
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.evaluate,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Validates the new transfer and returns the validation errors.
  Set<CubitValidationError<BeneficiaryTransferValidationErrorCode>>
      _validateTransfer() {
    final validationErrors =
        <CubitValidationError<BeneficiaryTransferValidationErrorCode>>{};

    final transfer = state.transfer;
    final beneficiaryType = transfer.beneficiaryType;

    if (transfer.source?.account == null) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode: BeneficiaryTransferValidationErrorCode
              .sourceAccountValidationError,
        ),
      );
    }

    if ((transfer.amount ?? 0.0) <= 0.0) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.amountValidationError,
        ),
      );
    }

    if ((transfer.amount ?? 0.0) >
        (transfer.source?.account?.availableBalance ?? 0.0)) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode: BeneficiaryTransferValidationErrorCode
              .insufficientBalanceValidationError,
        ),
      );
    }

    if (transfer.saveToShortcut &&
        (transfer.shortcutName ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode: BeneficiaryTransferValidationErrorCode
              .shortcutNameValidationError,
        ),
      );
    }

    if (transfer.scheduleDetails.recurrence != Recurrence.none &&
        transfer.scheduleDetails.startDate == null) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode: BeneficiaryTransferValidationErrorCode
              .scheduleDetailsValidationError,
        ),
      );
    }

    if (beneficiaryType == DestinationBeneficiaryType.newBeneficiary) {
      validationErrors.addAll(_validateNewBeneficiary());
    } else if (transfer.destination?.beneficiary == null) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode: BeneficiaryTransferValidationErrorCode
              .selectedBeneficiaryValidationError,
        ),
      );
    }

    return validationErrors;
  }

  /// Validates the new beneficiary and retruns a list of validation errors.
  Set<CubitValidationError<BeneficiaryTransferValidationErrorCode>>
      _validateNewBeneficiary() {
    final validationErrors =
        <CubitValidationError<BeneficiaryTransferValidationErrorCode>>{};

    final newBeneficiary = state.transfer.newBeneficiary;

    if ((newBeneficiary?.firstName ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.firstNameValidationError,
        ),
      );
    }

    if ((newBeneficiary?.lastName ?? '').isEmpty) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.lastNameValidationError,
        ),
      );
    }

    if (newBeneficiary?.country == null) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.countryValidationError,
        ),
      );
    }

    if (newBeneficiary?.currency == null) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.currencyValidationError,
        ),
      );
    }

    if ((newBeneficiary?.ibanOrAccountNO ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode: BeneficiaryTransferValidationErrorCode
              .ibanOrAccountValidationError,
        ),
      );
    }

    if ((newBeneficiary?.routingCode ?? '').trim().isEmpty &&
        (newBeneficiary?.routingCodeIsRequired ?? false)) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.routingCodeValidationError,
        ),
      );
    }

    if (newBeneficiary?.bank == null) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.bankValidationError,
        ),
      );
    }

    if ((newBeneficiary?.shouldSave ?? false) &&
        (newBeneficiary?.nickname ?? '').trim().isEmpty) {
      validationErrors.add(
        CubitValidationError<BeneficiaryTransferValidationErrorCode>(
          validationErrorCode:
              BeneficiaryTransferValidationErrorCode.nicknameValidationError,
        ),
      );
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
            ?.value,
      );

      if (!isValid) {
        validationErrors.add(
          CubitValidationError<BeneficiaryTransferValidationErrorCode>(
            validationErrorCode:
                BeneficiaryTransferValidationErrorCode.invalidIBAN,
          ),
        );
      }
    }

    return validationErrors;
  }

  /// Submits the transfer.
  Future<void> submit() async {
    if (state.actions.contains(BeneficiaryTransferAction.submit)) {
      return;
    }

    final deviceUID = _generateDeviceUIDUseCase(30);

    emit(
      state.copyWith(
        transfer: state.transfer.copyWith(deviceUID: deviceUID),
        actions: state.addAction(
          BeneficiaryTransferAction.submit,
        ),
        errors: state.removeErrorForAction(
          BeneficiaryTransferAction.submit,
        ),
        events: state.removeEvents(
          {
            BeneficiaryTransferEvent.showResultView,
            BeneficiaryTransferEvent.openSecondFactor,
          },
        ),
      ),
    );

    try {
      final transferResult = await _submitTransferUseCase(
        transfer: state.transfer,
        editMode: state.editMode,
      );

      switch (transferResult.status) {
        case TransferStatus.completed:
        case TransferStatus.pending:
        case TransferStatus.scheduled:
          if (state.transfer.saveToShortcut) {
            await _createShortcut();
          }

          emit(
            state.copyWith(
              actions: state.removeAction(
                BeneficiaryTransferAction.submit,
              ),
              transferResult: transferResult,
              events: state.addEvent(
                BeneficiaryTransferEvent.showResultView,
              ),
            ),
          );
          break;

        case TransferStatus.failed:
          emit(
            state.copyWith(
              actions: state.removeAction(
                BeneficiaryTransferAction.submit,
              ),
              errors: state.addCustomCubitError(
                action: BeneficiaryTransferAction.submit,
                code: CubitErrorCode.transferFailed,
              ),
            ),
          );
          break;

        case TransferStatus.otp:
          emit(
            state.copyWith(
              actions: state.removeAction(
                BeneficiaryTransferAction.submit,
              ),
              transferResult: transferResult,
              events: state.addEvent(
                BeneficiaryTransferEvent.openSecondFactor,
              ),
            ),
          );
          break;

        default:
          _logger.severe(
            'Unhandled transfer status -> ${transferResult.status}',
          );
          throw Exception(
            'Unhandled transfer status -> ${transferResult.status}',
          );
      }
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.submit,
          ),
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.submit,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current transfer result.
  Future<void> sendOTPCode() async {
    assert(state.transferResult != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          BeneficiaryTransferAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          BeneficiaryTransferAction.sendOTPCode,
        ),
        events: state.removeEvent(
          BeneficiaryTransferEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final transferResult = await _sendOTPCodeForTransferUseCase(
        transferId: state.transferResult?.id ?? 0,
        editMode: state.editMode,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.sendOTPCode,
          ),
          transferResult: transferResult,
          events: state.addEvent(
            BeneficiaryTransferEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the transfer retrievied on the [submit]
  /// method.
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
          BeneficiaryTransferAction.verifySecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final transferResult = await _verifyTransferSecondFactorUseCase(
        transferId: state.transferResult?.id ?? 0,
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
      );

      if (state.transfer.saveToShortcut) {
        await _createShortcut();
      }

      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          transferResult: transferResult,
          events: state.addEvent(
            BeneficiaryTransferEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.verifySecondFactor,
            exception: e,
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
        actions: state.addAction(
          BeneficiaryTransferAction.resendSecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final transferResult = await _resendTransferSecondFactorUseCase(
        transfer: state.transfer,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          transferResult: transferResult,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.resendSecondFactor,
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
          BeneficiaryTransferAction.shortcut,
        ),
        errors: state.removeErrorForAction(
          BeneficiaryTransferAction.shortcut,
        ),
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
          actions: state.removeAction(
            BeneficiaryTransferAction.shortcut,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.shortcut,
          ),
          errors: state.addErrorFromException(
            action: BeneficiaryTransferAction.shortcut,
            exception: e,
          ),
        ),
      );
    }
  }
}
