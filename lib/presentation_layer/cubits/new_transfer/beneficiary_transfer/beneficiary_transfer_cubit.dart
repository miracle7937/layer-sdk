import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            banksPagination: Pagination(limit: 20),
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
          actions: state.addAction(
            BeneficiaryTransferAction.reasons,
          ),
          errors: state.removeCubitError(
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
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.reasons,
            ),
            errors: state.addCubitError(
              action: BeneficiaryTransferAction.reasons,
              exception: e,
            ),
          ),
        );
      }
    }
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
          errors: state.removeCubitError(
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
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state
                .removeAction(BeneficiaryTransferAction.beneficiarySettings),
            errors: state.addCubitError(
              action: BeneficiaryTransferAction.beneficiarySettings,
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
          errors: state.removeCubitError(
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
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.currencies,
            ),
            errors: state.addCubitError(
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
          errors: state.removeCubitError(
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
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.countries,
            ),
            errors: state.addCubitError(
              action: BeneficiaryTransferAction.countries,
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
          errors: state.removeCubitError(
            BeneficiaryTransferAction.accounts,
          ),
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
            actions: state.removeAction(
              BeneficiaryTransferAction.accounts,
            ),
            accounts: accounts,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.accounts,
            ),
            errors: state.addCubitError(
              action: BeneficiaryTransferAction.accounts,
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
          errors: state.removeCubitError(
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
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.beneficiaries,
            ),
            errors: state.addCubitError(
              action: BeneficiaryTransferAction.beneficiaries,
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
        errors: state.removeCubitError(
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
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.banks,
          ),
          errors: state.addCubitError(
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

    final beneficiaryType = state.transfer.beneficiaryType;
    final shouldValidateIBAN =
        beneficiaryType == DestinationBeneficiaryType.newBeneficiary &&
            state.transfer.newBeneficiary?.routingCode == null;
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
            actions: state.removeAction(BeneficiaryTransferAction.evaluate),
            errors: state.addCustomCubitError(
              action: BeneficiaryTransferAction.evaluate,
              code: CubitErrorCode.invalidIBAN,
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
          actions: state.removeAction(
            BeneficiaryTransferAction.evaluate,
          ),
          events: state.addEvent(
            BeneficiaryTransferEvent.showConfirmationView,
          ),
          evaluation: evaluation,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.evaluate,
          ),
          errors: state.addCubitError(
            action: BeneficiaryTransferAction.evaluate,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Submits the transfer.
  Future<void> submit() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          BeneficiaryTransferAction.submit,
        ),
        errors: state.removeCubitError(
          BeneficiaryTransferAction.submit,
        ),
        events: state.removeEvents(
          {
            BeneficiaryTransferEvent.showResultView,
            BeneficiaryTransferEvent.inputOTPCode,
          },
        ),
      ),
    );

    if (state.transfer.saveToShortcut) {
      await _createShortcut();

      if (state.errors
          .where((error) => error.action == BeneficiaryTransferAction.shortcut)
          .isNotEmpty) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              BeneficiaryTransferAction.submit,
            ),
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

      switch (transferResult.status) {
        case TransferStatus.completed:
        case TransferStatus.pending:
        case TransferStatus.scheduled:
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
                BeneficiaryTransferEvent.inputOTPCode,
              ),
            ),
          );
          break;

        default:
          throw Exception(
            'Unhandled transfer status -> ${transferResult.status}',
          );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.submit,
          ),
          errors: state.addCubitError(
            action: BeneficiaryTransferAction.submit,
            exception: e,
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
        actions: state.addAction(
          BeneficiaryTransferAction.verifySecondFactor,
        ),
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
          actions: state.removeAction(
            BeneficiaryTransferAction.verifySecondFactor,
          ),
          transferResult: transferResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.verifySecondFactor,
          ),
          errors: state.addCubitError(
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
          transferResult: transferResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.resendSecondFactor,
          ),
          errors: state.addCubitError(
            action: BeneficiaryTransferAction.resendSecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Creates the shortcut (if enabled) once the transfer has succeded.
  Future<void> _createShortcut() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          BeneficiaryTransferAction.shortcut,
        ),
        errors: state.removeCubitError(
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
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            BeneficiaryTransferAction.shortcut,
          ),
          errors: state.addCubitError(
            action: BeneficiaryTransferAction.shortcut,
            exception: e,
          ),
        ),
      );
    }
  }
}
