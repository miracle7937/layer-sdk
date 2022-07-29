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
  final LoadAvailableCurrenciesUseCase _loadAvailableCurrenciesUseCase;
  final LoadBanksByCountryCodeUseCase _loadBanksByCountryCodeUseCase;
  final AddNewBeneficiaryUseCase _addNewBeneficiaryUseCase;

  /// Creates a new cubit using the supplied [LoadAvailableCurrenciesUseCase].
  AddBeneficiaryCubit({
    required LoadCountriesUseCase loadCountriesUseCase,
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
    required LoadAvailableCurrenciesUseCase loadAvailableCurrenciesUseCase,
    required LoadBanksByCountryCodeUseCase loadBanksByCountryCodeUseCase,
    required AddNewBeneficiaryUseCase addNewBeneficiariesUseCase,
  })  : _loadCountriesUseCase = loadCountriesUseCase,
        _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _loadAvailableCurrenciesUseCase = loadAvailableCurrenciesUseCase,
        _loadBanksByCountryCodeUseCase = loadBanksByCountryCodeUseCase,
        _addNewBeneficiaryUseCase = addNewBeneficiariesUseCase,
        super(AddBeneficiaryState());

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
        errorStatus: AddBeneficiaryErrorStatus.none,
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
        _loadAvailableCurrenciesUseCase(
          forceRefresh: forceRefresh,
        )
      ]);
      final countries = futures[0] as List<Country>;
      final accounts = futures[1] as List<Account>;
      final currencies = futures[2] as List<Currency>;
      // final currencies = await _loadAvailableCurrenciesUseCase(
      //   forceRefresh: forceRefresh,
      // );
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
          ),
          countries: countries,
          selectedCurrency: selectedCurrency,
          availableCurrencies: currencies,
          busy: false,
          action: AddBeneficiaryAction.initAction,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: AddBeneficiaryAction.none,
          errorStatus: e is NetException
              ? AddBeneficiaryErrorStatus.network
              : AddBeneficiaryErrorStatus.generic,
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
      );

  /// Handles event of sort code changes.
  void onSortCodeChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          sortCode: text,
        ),
      );

  /// Handles event of IBAN changes.
  void onIbanChange(String text) => _emitBeneficiary(
        state.beneficiary?.copyWith(
          iban: text,
        ),
      );

  void _emitBeneficiary(Beneficiary? beneficiary) => emit(
        state.copyWith(
          beneficiary: beneficiary,
          action: AddBeneficiaryAction.editAction,
          errorStatus: AddBeneficiaryErrorStatus.none,
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
          errorStatus: AddBeneficiaryErrorStatus.none,
        ),
      );

  /// Handles the country change.
  void onCountryChanged(Country country) async {
    emit(
      state.copyWith(
        selectedCountry: country,
        action: AddBeneficiaryAction.editAction,
        busy: true,
        errorStatus: AddBeneficiaryErrorStatus.none,
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
          errorStatus: e is NetException
              ? AddBeneficiaryErrorStatus.network
              : AddBeneficiaryErrorStatus.generic,
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
          errorStatus: AddBeneficiaryErrorStatus.none,
        ),
      );

  /// Handles the adding new beneficiary.
  void onAdd() async {
    emit(
      state.copyWith(
        action: AddBeneficiaryAction.add,
        busy: true,
        errorStatus: AddBeneficiaryErrorStatus.none,
      ),
    );
    try {
      final accountRequired = state.accountRequired;
      final beneficiary = state.beneficiary!.copyWith(
        accountNumber: accountRequired ? state.beneficiary!.accountNumber! : '',
        sortCode: accountRequired ? state.beneficiary!.sortCode! : '',
        iban: accountRequired ? '' : state.beneficiary!.iban!,
      );
      final newBeneficiary = await _addNewBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      emit(
        state.copyWith(
          busy: false,
          action: AddBeneficiaryAction.none,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: AddBeneficiaryAction.none,
          errorStatus: e is NetException
              ? AddBeneficiaryErrorStatus.network
              : AddBeneficiaryErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
