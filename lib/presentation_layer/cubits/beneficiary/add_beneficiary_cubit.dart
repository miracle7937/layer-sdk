import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';

import '../../cubits.dart';
import '../../utils.dart';

/// A cubit that handles adding a new beneficiary.
class AddBeneficiaryCubit extends Cubit<AddBeneficiaryState> {
  final _logger = Logger('AddBeneficiaryCubit');

  final LoadCountriesUseCase _loadCountriesUseCase;
  final LoadCurrentCustomerUseCase _loadCustomerUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadBanksByCountryCodeUseCase _loadBanksByCountryCodeUseCase;
  final ValidateAccountUseCase _validateAccountUseCase;
  final ValidateIBANUseCase _validateIBANUseCase;
  final AddNewBeneficiaryUseCase _addNewBeneficiaryUseCase;
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;
  final SendOTPCodeForBeneficiaryUseCase _sendOTPCodeForBeneficiaryUseCase;
  final VerifyBeneficiarySecondFactorUseCase
      _verifyBeneficiarySecondFactorUseCase;
  final ResendBeneficiarySecondFactorUseCase
      _resendBeneficiarySecondFactorUseCase;

  /// Creates a new [AddBeneficiaryCubit].
  AddBeneficiaryCubit({
    required LoadCountriesUseCase loadCountriesUseCase,
    required LoadAllCurrenciesUseCase loadAvailableCurrenciesUseCase,
    required LoadBanksByCountryCodeUseCase loadBanksByCountryCodeUseCase,
    required ValidateAccountUseCase validateAccountUseCase,
    required ValidateIBANUseCase validateIBANUseCase,
    required AddNewBeneficiaryUseCase addNewBeneficiariesUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
    required LoadCurrentCustomerUseCase loadCustomerUseCase,
    required SendOTPCodeForBeneficiaryUseCase sendOTPCodeForBeneficiaryUseCase,
    required VerifyBeneficiarySecondFactorUseCase
        verifyBeneficiarySecondFactorUseCase,
    required ResendBeneficiarySecondFactorUseCase
        resendBeneficiarySecondFactorUseCase,
    TransferType? beneficiaryType,
  })  : _loadCountriesUseCase = loadCountriesUseCase,
        _loadAllCurrenciesUseCase = loadAvailableCurrenciesUseCase,
        _loadBanksByCountryCodeUseCase = loadBanksByCountryCodeUseCase,
        _validateAccountUseCase = validateAccountUseCase,
        _validateIBANUseCase = validateIBANUseCase,
        _addNewBeneficiaryUseCase = addNewBeneficiariesUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        _loadCustomerUseCase = loadCustomerUseCase,
        _sendOTPCodeForBeneficiaryUseCase = sendOTPCodeForBeneficiaryUseCase,
        _verifyBeneficiarySecondFactorUseCase =
            verifyBeneficiarySecondFactorUseCase,
        _resendBeneficiarySecondFactorUseCase =
            resendBeneficiarySecondFactorUseCase,
        super(
          AddBeneficiaryState(
            beneficiaryType: beneficiaryType,
            banksPagination: Pagination(limit: 20),
          ),
        );

  /// Loads initial data:
  /// - countries;
  /// - accounts(for preselecting currency);
  /// - available currencies;
  /// - banks.
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(AddBeneficiaryAction.initialize),
        errors: state.removeErrorForAction(AddBeneficiaryAction.initialize),
      ),
    );

    try {
      final futures = await Future.wait([
        _loadCountriesUseCase(
          forceRefresh: forceRefresh,
        ),
        _loadAllCurrenciesUseCase(
          forceRefresh: forceRefresh,
        ),
        _loadGlobalSettingsUseCase(
          codes: [
            'benef_iban_allowed_characters',
            'benef_acc_num_allowed_characters',
            'benef_acc_num_minimum_characters',
            'benef_acc_num_maximum_characters',
          ],
        ),
        _loadCustomerUseCase(),
      ]);

      final countries = futures[0] as List<Country>;
      final currencies = futures[1] as List<Currency>;
      final beneficiarySettings = futures[2] as List<GlobalSetting>;
      final customer = futures[3] as Customer;

      final customerCountry = countries.firstWhereOrNull(
        (e) => e.countryCode == customer.country,
      );

      final selectedCurrency = currencies.firstWhereOrNull(
        (e) => e.code == customerCountry?.currency,
      );

      /// TODO: cubit_issue | Why is the action being used here like this.
      /// The action is just for letting the user know what action is being
      /// processed. If the loading was done, the action should be `none`.
      emit(
        state.copyWith(
          actions: state.removeAction(AddBeneficiaryAction.initialize),
          beneficiary: Beneficiary(
            nickname: '',
            firstName: '',
            lastName: '',
            middleName: '',
            bankName: '',
            currency: selectedCurrency?.code,
            type: state.beneficiaryType,
          ),
          countries: countries,
          selectedCurrency: selectedCurrency,
          availableCurrencies: currencies,
          beneficiarySettings: beneficiarySettings,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(AddBeneficiaryAction.initialize),
          errors: state.addErrorFromException(
            action: AddBeneficiaryAction.initialize,
            exception: e,
          ),
        ),
      );
    }
  }

  /// TODO: cubit_issue | So many method for changing an specific value from
  /// the beneficiary. Would be better to have only one method that handles the
  /// changes.
  /// Handles event of first name changes.
  void onFirstNameChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          firstName: text,
        ),
      );

  /// Handles event of last name changes.
  void onLastNameChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          lastName: text,
        ),
      );

  /// Handles event of nickname changes.
  void onNicknameChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          nickname: text,
        ),
      );

  /// Handles event of first line of address changes.
  void onAddress1Change(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          address1: text,
        ),
      );

  /// Handles event of second line of address changes.
  void onAddress2Change(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          address2: text,
        ),
      );

  /// Handles event of third line of address changes.
  void onAddress3Change(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          address3: text,
        ),
      );

  /// Handles event of account changes.
  void onAccountChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          accountNumber: text,
        ),
      );

  /// Handles event of routing code changes.
  void onRoutingCodeChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          routingCode: text,
        ),
      );

  /// Handles event of IBAN changes.
  void onIbanChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          iban: text,
        ),
      );

  /// Emits state with beneficiary and removes [errorStatus] if provided.
  void _emitBeneficiary(Beneficiary? beneficiary) => emit(
        state.copyWith(
          beneficiary: beneficiary,
        ),
      );

  /// TODO: cubit_issue | You are using a method called `_emitBeneficiary` all
  /// the time for updating the beneficiary details, but for the following
  /// methods you are not using that anymore. This is very confusing for
  /// someone that has not developed the cubit.
  ///
  /// Handles the currency change.
  void onCurrencyChanged(Currency currency) => emit(
        state.copyWith(
          beneficiary: state.beneficiary?.copyWith(
            currency: currency.code,
          ),
          selectedCurrency: currency,
        ),
      );

  /// Handles the country change.
  void onCountryChanged(Country country) async {
    emit(
      state.copyWith(
        selectedCountry: country,
      ),
    );
    loadBanks();
  }

  /// Handles the bank change.
  void onBankChanged(Bank bank) => emit(
        state.copyWith(
          beneficiary: state.beneficiary?.copyWith(
            bank: bank,
          ),
        ),
      );

  /// Loads the banks for the passed country code.
  Future<void> loadBanks({
    bool loadMore = false,
  }) async {
    final countryCode = state.selectedCountry?.countryCode;
    if (countryCode == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(AddBeneficiaryAction.banks),
        errors: state.removeErrorForAction(AddBeneficiaryAction.banks),
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
          actions: state.removeAction(AddBeneficiaryAction.banks),
          banks: banks,
          banksPagination: newPage.refreshCanLoadMore(
            loadedCount: resultList.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(AddBeneficiaryAction.banks),
          errors: state.addErrorFromException(
            action: AddBeneficiaryAction.banks,
            exception: e,
          ),
        ),
      );
    }
  }

  /// TODO: cubit_issue | This method is not descriptive at all. Let's maybe
  /// skip this and merge it to the `loadBanks` method.
  /// Updates the bank query.
  Future<void> onChanged({
    String? bankQuery,
  }) async {
    emit(
      state.copyWith(
        bankQuery: bankQuery,
      ),
    );
    if (bankQuery != null) {
      loadBanks();
    }
  }

  /// TODO: cubit_issue | Not very descriptive. This should be called something
  /// like `submit` or `submitBeneficiary`.
  ///
  /// Handles the adding new beneficiary.
  Future<void> onAdd() async {
    final accountRequired = state.accountRequired;
    if (accountRequired) {
      final maxChars = state.beneficiarySettings
          .singleWhereOrNull(
              (element) => element.code == 'benef_acc_num_maximum_characters')
          ?.value;
      final minChars = state.beneficiarySettings
          .singleWhereOrNull(
              (element) => element.code == 'benef_acc_num_minimum_characters')
          ?.value;
      final isAccountValid = _validateAccountUseCase(
        account: state.beneficiary?.accountNumber ?? '',
        allowedCharacters: state.beneficiarySettings
            .singleWhereOrNull(
                (element) => element.code == 'benef_acc_num_allowed_characters')
            ?.value,
        minAccountChars:
            minChars is int ? minChars : (int.tryParse(minChars ?? '') ?? 8),
        maxAccountChars:
            maxChars is int ? maxChars : (int.tryParse(maxChars ?? '') ?? 30),
      );

      if (!isAccountValid) {
        emit(
          state.copyWith(
            errors: state.addValidationError(
              validationErrorCode:
                  AddBeneficiaryValidationErrorCode.invalidAccount,
            ),
          ),
        );

        return;
      }
    } else {
      final isIbanValid = _validateIBANUseCase(
        iban: state.beneficiary?.iban ?? '',
        allowedCharacters: state.beneficiarySettings
            .singleWhereOrNull(
                (element) => element.code == 'benef_iban_allowed_characters')
            ?.value,
      );

      if (!isIbanValid) {
        emit(
          state.copyWith(
            errors: state.addValidationError(
              validationErrorCode:
                  AddBeneficiaryValidationErrorCode.invalidIBAN,
            ),
          ),
        );

        return;
      }
    }

    emit(
      state.copyWith(
        actions: state.addAction(AddBeneficiaryAction.add),
        errors: state.removeErrorForAction(AddBeneficiaryAction.add),
        events: state.removeEvents(
          const {
            AddBeneficiaryEvent.openSecondFactor,
            AddBeneficiaryEvent.showResultView,
          },
        ),
      ),
    );

    try {
      /// TODO: cubit_issue | At this point, the beneficiary should be ready.
      /// Why are we changing it before sending it? I don't understand. The
      /// values that you are clearing should be already empty or null
      /// at this stage.
      final beneficiary = state.beneficiary!.copyWith(
        accountNumber: accountRequired ? state.beneficiary!.accountNumber! : '',
        routingCode: accountRequired ? state.beneficiary!.routingCode! : '',
        iban: accountRequired ? '' : state.beneficiary!.iban!,
      );

      /// TODO: cubit_issue | I think we should keep separated the beneficiary
      /// item that we were creating and the beneficiary result that BE is
      /// sending back.
      ///
      /// Also I think the action usage is not coherent with the rest os cubits
      /// that we have on the sdk. As I stated before, the actions are for
      /// indicating the type of loading that it's being done by the cubit.
      /// You are using them as actions that the UI should perform later on.
      ///
      /// For that, you should be using [BlocListener]s on the UI.
      ///
      final newBeneficiary = await _addNewBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      switch (newBeneficiary.status) {
        case BeneficiaryStatus.active:
        case BeneficiaryStatus.pending:
          emit(
            state.copyWith(
              beneficiary: newBeneficiary,
              actions: state.removeAction(AddBeneficiaryAction.add),
              events: state.addEvent(AddBeneficiaryEvent.showResultView),
            ),
          );
          break;

        case BeneficiaryStatus.otp:
          emit(
            state.copyWith(
              beneficiary: newBeneficiary,
              actions: state.removeAction(AddBeneficiaryAction.add),
              events: state.addEvent(AddBeneficiaryEvent.openSecondFactor),
            ),
          );
          break;

        default:
          _logger.severe(
            'Unhandled beneficiary status -> ${newBeneficiary.status}',
          );
          throw Exception(
            'Unhandled beneficiary status -> ${newBeneficiary.status}',
          );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(AddBeneficiaryAction.add),
          errors: state.addErrorFromException(
            action: AddBeneficiaryAction.add,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current beneficiary.
  Future<void> sendOTPCode() async {
    assert(state.beneficiary != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          AddBeneficiaryAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          AddBeneficiaryAction.sendOTPCode,
        ),
        events: state.removeEvent(
          AddBeneficiaryEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final beneficiaryResult = await _sendOTPCodeForBeneficiaryUseCase(
        beneficiaryId: state.beneficiary?.id ?? 0,
        editMode: false,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            AddBeneficiaryAction.sendOTPCode,
          ),
          beneficiary: beneficiaryResult,
          events: state.addEvent(
            AddBeneficiaryEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AddBeneficiaryAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: AddBeneficiaryAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the beneficiary retrievied on the [onAdd]
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

    assert(state.beneficiary != null);
    if (state.beneficiary == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(
          AddBeneficiaryAction.verifySecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final beneficiaryResult = await _verifyBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary!,
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            AddBeneficiaryAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          beneficiary: beneficiaryResult,
          events: state.addEvent(
            AddBeneficiaryEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AddBeneficiaryAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: AddBeneficiaryAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resends the second factor for the beneficiary retrievied on the [onAdd]
  /// method.
  Future<void> resendSecondFactor() async {
    assert(state.beneficiary != null);
    if (state.beneficiary == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(
          AddBeneficiaryAction.resendSecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final beneficiaryResult = await _resendBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary!,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            AddBeneficiaryAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          beneficiary: beneficiaryResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AddBeneficiaryAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: AddBeneficiaryAction.resendSecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }
}
