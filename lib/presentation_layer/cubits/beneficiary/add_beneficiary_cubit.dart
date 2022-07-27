import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps the list of beneficiary.
class AddBeneficiaryCubit extends Cubit<AddBeneficiaryState> {
  final LoadCountriesUseCase _loadCountriesUseCase;
  final GetCustomerAccountsUseCase _getCustomerAccountsUseCase;
  final LoadAvailableCurrenciesUseCase _loadAvailableCurrenciesUseCase;
  final LoadBanksByCountryCodeUseCase _loadBanksByCountryCodeUseCase;

  /// Creates a new cubit using the supplied [LoadAvailableCurrenciesUseCase].
  AddBeneficiaryCubit({
    required LoadCountriesUseCase loadCountriesUseCase,
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
    required LoadAvailableCurrenciesUseCase loadAvailableCurrenciesUseCase,
    required LoadBanksByCountryCodeUseCase loadBanksByCountryCodeUseCase,
  })  : _loadCountriesUseCase = loadCountriesUseCase,
        _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _loadAvailableCurrenciesUseCase = loadAvailableCurrenciesUseCase,
        _loadBanksByCountryCodeUseCase = loadBanksByCountryCodeUseCase,
        super(AddBeneficiaryState());

  /// Loads initial data:
  /// - accounts(for preselecting currency);
  /// - available currencies.
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

  /// Handles the currency change.
  void onCurrencyChanged(Currency currency) => emit(
        state.copyWith(
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
}
