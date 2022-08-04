import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles adding a new beneficiary.
class AddBeneficiaryCubit extends Cubit<AddBeneficiaryState> {
  final LoadCountriesUseCase _loadCountriesUseCase;
  final GetCustomerAccountsUseCase _getCustomerAccountsUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadBanksByCountryCodeUseCase _loadBanksByCountryCodeUseCase;
  final ValidateAccountUseCase _validateAccountUseCase;
  final ValidateIBANUseCase _validateIBANUseCase;
  final AddNewBeneficiaryUseCase _addNewBeneficiaryUseCase;
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

  /// Creates a new [AddBeneficiaryCubit].
  AddBeneficiaryCubit({
    required LoadCountriesUseCase loadCountriesUseCase,
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
    required LoadAllCurrenciesUseCase loadAvailableCurrenciesUseCase,
    required LoadBanksByCountryCodeUseCase loadBanksByCountryCodeUseCase,
    required ValidateAccountUseCase validateAccountUseCase,
    required ValidateIBANUseCase validateIBANUseCase,
    required AddNewBeneficiaryUseCase addNewBeneficiariesUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
    TransferType? beneficiaryType,
  })  : _loadCountriesUseCase = loadCountriesUseCase,
        _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _loadAllCurrenciesUseCase = loadAvailableCurrenciesUseCase,
        _loadBanksByCountryCodeUseCase = loadBanksByCountryCodeUseCase,
        _validateAccountUseCase = validateAccountUseCase,
        _validateIBANUseCase = validateIBANUseCase,
        _addNewBeneficiaryUseCase = addNewBeneficiariesUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        super(
          AddBeneficiaryState(
            beneficiaryType: beneficiaryType,
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
        busy: true,
        errors: {},
      ),
    );

    try {
      final futures = await Future.wait([
        _loadCountriesUseCase(
          forceRefresh: forceRefresh,
        ),
        _getCustomerAccountsUseCase(
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
        )
      ]);
      final countries = futures[0] as List<Country>;
      final accounts = futures[1] as List<Account>;
      final currencies = futures[2] as List<Currency>;
      final beneficiarySettings = futures[3] as List<GlobalSetting>;

      final selectedCurrency = accounts.isEmpty
          ? null
          : currencies.firstWhereOrNull(
              (currency) => accounts.first.currency == currency.code,
            );

      emit(
        state.copyWith(
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
          busy: false,
          action: AddBeneficiaryAction.initAction,
          beneficiarySettings: beneficiarySettings,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: AddBeneficiaryAction.none,
          errors: _addError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: e is NetException
                ? AddBeneficiaryErrorStatus.network
                : AddBeneficiaryErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : null,
          ),
        ),
      );

      rethrow;
    }
  }

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
        AddBeneficiaryErrorStatus.invalidAccount,
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
        AddBeneficiaryErrorStatus.invalidIBAN,
      );

  /// Emits state with beneficiary and removed [errorStatus] if provided.
  void _emitBeneficiary(
    Beneficiary? beneficiary, [
    AddBeneficiaryErrorStatus? errorStatus,
  ]) =>
      emit(
        state.copyWith(
          beneficiary: beneficiary,
          action: AddBeneficiaryAction.editAction,
          errors: errorStatus == null
              ? _removeDefault()
              : _removeDefault()
                  .where((error) => error.errorStatus != errorStatus)
                  .toSet(),
        ),
      );

  /// Handles the currency change.
  void onCurrencyChanged(Currency currency) => emit(
        state.copyWith(
          beneficiary: state.beneficiary?.copyWith(
            currency: currency.code,
          ),
          selectedCurrency: currency,
          action: AddBeneficiaryAction.editAction,
          errors: _removeDefault(),
        ),
      );

  /// Handles the country change.
  void onCountryChanged(Country country) async {
    emit(
      state.copyWith(
        selectedCountry: country,
        action: AddBeneficiaryAction.editAction,
        busy: true,
        errors: _removeDefault(),
      ),
    );
    try {
      final banks = await _loadBanksByCountryCodeUseCase(
        countryCode: country.countryCode ?? '',
      );

      emit(
        state.copyWith(
          beneficiary: state.beneficiary?.copyWith(
            bank: null,
          ),
          banks: banks,
          busy: false,
          action: AddBeneficiaryAction.none,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: AddBeneficiaryAction.none,
          errors: _addError(
            action: AddBeneficiaryAction.editAction,
            errorStatus: e is NetException
                ? AddBeneficiaryErrorStatus.network
                : AddBeneficiaryErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : null,
          ),
        ),
      );

      rethrow;
    }
  }

  /// Handles the bank change.
  void onBankChanged(Bank bank) => emit(
        state.copyWith(
          beneficiary: state.beneficiary?.copyWith(
            bank: bank,
          ),
          action: AddBeneficiaryAction.editAction,
          errors: _removeDefault(),
        ),
      );

  /// Handles the adding new beneficiary.
  void onAdd() async {
    final accountRequired = state.accountRequired;
    if (accountRequired) {
      final isAccountValid = _validateAccountUseCase(
        account: state.beneficiary?.accountNumber ?? '',
        allowedCharacters: state.beneficiarySettings
            .singleWhereOrNull(
                (element) => element.code == 'benef_acc_num_allowed_characters')
            ?.value,
        minAccountChars: state.beneficiarySettings
            .singleWhereOrNull(
                (element) => element.code == 'benef_acc_num_minimum_characters')
            ?.value,
        maxAccountChars: state.beneficiarySettings
            .singleWhereOrNull(
                (element) => element.code == 'benef_acc_num_maximum_characters')
            ?.value,
      );
      if (!isAccountValid) {
        emit(
          state.copyWith(
            errors: _addError(
              action: AddBeneficiaryAction.editAction,
              errorStatus: AddBeneficiaryErrorStatus.invalidAccount,
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
            ?.value
            ?.split(''),
      );
      if (!isIbanValid) {
        emit(
          state.copyWith(
            errors: _addError(
              action: AddBeneficiaryAction.editAction,
              errorStatus: AddBeneficiaryErrorStatus.invalidIBAN,
            ),
          ),
        );
        return;
      }
    }
    emit(
      state.copyWith(
        action: AddBeneficiaryAction.add,
        busy: true,
        errors: _removeDefault(),
      ),
    );
    try {
      final beneficiary = state.beneficiary!.copyWith(
        accountNumber: accountRequired ? state.beneficiary!.accountNumber! : '',
        routingCode: accountRequired ? state.beneficiary!.routingCode! : '',
        iban: accountRequired ? '' : state.beneficiary!.iban!,
      );
      final newBeneficiary = await _addNewBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      emit(
        state.copyWith(
          beneficiary: newBeneficiary,
          busy: false,
          action: newBeneficiary.otpId == null
              ? AddBeneficiaryAction.success
              : AddBeneficiaryAction.otpRequired,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: AddBeneficiaryAction.none,
          errors: _addError(
            action: AddBeneficiaryAction.add,
            errorStatus: e is NetException
                ? AddBeneficiaryErrorStatus.network
                : AddBeneficiaryErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : null,
          ),
        ),
      );

      rethrow;
    }
  }

  /// Returns an error list that includes the passed action and error status.
  Set<AddBeneficiaryError> _addError({
    required AddBeneficiaryAction action,
    required AddBeneficiaryErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        AddBeneficiaryError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Returns an error list containing all the errors but the one that
  /// coincides with the passed action.
  Set<AddBeneficiaryError> _removeError(
    AddBeneficiaryError action,
  ) =>
      state.errors.where((error) => error.action != action).toSet();

  Set<AddBeneficiaryError> _removeDefault() => state.errors
      .where((error) => ![
            AddBeneficiaryErrorStatus.network,
            AddBeneficiaryErrorStatus.generic,
          ].contains(error.errorStatus))
      .toSet();
}
