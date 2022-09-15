import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadCountriesUseCase extends Mock implements LoadCountriesUseCase {}

class MockLoadCurrentCustomerUseCase extends Mock
    implements LoadCurrentCustomerUseCase {}

class MockLoadAllCurrenciesUseCase extends Mock
    implements LoadAllCurrenciesUseCase {}

class MockLoadBanksByCountryCodeUseCase extends Mock
    implements LoadBanksByCountryCodeUseCase {}

class MockValidateAccountUseCase extends Mock
    implements ValidateAccountUseCase {}

class MockValidateIBANUseCase extends Mock implements ValidateIBANUseCase {}

class MockAddNewBeneficiaryUseCase extends Mock
    implements AddNewBeneficiaryUseCase {}

class MockLoadGlobalSettingsUseCase extends Mock
    implements LoadGlobalSettingsUseCase {}

class MockBank extends Mock implements Bank {}

final _loadCountriesUseCase = MockLoadCountriesUseCase();
final _loadCustomerUseCase = MockLoadCurrentCustomerUseCase();
final _loadAllCurrenciesUseCase = MockLoadAllCurrenciesUseCase();
final _loadBanksByCountryCodeUseCase = MockLoadBanksByCountryCodeUseCase();
final _validateAccountUseCase = MockValidateAccountUseCase();
final _validateIBANUseCase = MockValidateIBANUseCase();
final _addNewBeneficiaryUseCase = MockAddNewBeneficiaryUseCase();
final _loadGlobalSettingsUseCase = MockLoadGlobalSettingsUseCase();

final _countriesList = [
  Country(countryCode: 'GB', currency: 'GBP'),
  Country(countryCode: 'IE', currency: 'EUR'),
];
final _selectedCountry = _countriesList.first;

final _banksCount = 83;
final _banksPaginationLimit = 20;
final _mockedBanksList = List.generate(_banksCount, (index) => MockBank());
final _mockedSelectedBank = _mockedBanksList.first;

final _currencyEur = Currency(code: 'EUR');
final _currencyGbp = Currency(code: 'GBP');
final _currenciesList = [
  _currencyEur,
  _currencyGbp,
];

final Customer _customer = Customer(
  id: '',
  addresses: [
    Address(country: 'GB'),
  ],
);

final String _allowedCharactersForIban = 'abcedfghijklmnopqrstuvwxyz'
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
final String _allowedCharactersForAccount = '1234567890';
final int _minAccountCharsForAccount = 8;
final int _maxAccountCharsForAccount = 15;

final _globalSettingsCodes = [
  'benef_iban_allowed_characters',
  'benef_acc_num_allowed_characters',
  'benef_acc_num_minimum_characters',
  'benef_acc_num_maximum_characters',
];
final _globalSettingsValues = [
  _allowedCharactersForIban,
  _allowedCharactersForAccount,
  _minAccountCharsForAccount,
  _maxAccountCharsForAccount,
];
final _globalSettingsTypes = [
  GlobalSettingType.string,
  GlobalSettingType.string,
  GlobalSettingType.int,
  GlobalSettingType.int,
];
final _globalSettingList = List.generate(
  _globalSettingsCodes.length,
  (index) => GlobalSetting(
    code: _globalSettingsCodes[index],
    module: 'module',
    value: _globalSettingsValues[index],
    type: _globalSettingsTypes[index],
  ),
);

late AddBeneficiaryCubit _cubit;

final _beneficiaryType = TransferType.international;

/// When cubit loaded all required data
final _loadedState = AddBeneficiaryState(
  banksPagination: Pagination(limit: _banksPaginationLimit),
  beneficiaryType: _beneficiaryType,
  beneficiary: Beneficiary(
    nickname: '',
    firstName: '',
    lastName: '',
    middleName: '',
    bankName: '',
    currency: _currencyGbp.code,
    type: _beneficiaryType,
  ),
  countries: _countriesList,
  selectedCurrency: _currencyGbp,
  availableCurrencies: _currenciesList,
  beneficiarySettings: _globalSettingList,
  action: AddBeneficiaryAction.none,
);

final _netException = NetException(
  code: 'code',
  message: 'message',
);

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _cubit = AddBeneficiaryCubit(
      loadCountriesUseCase: _loadCountriesUseCase,
      loadCustomerUseCase: _loadCustomerUseCase,
      loadAvailableCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadBanksByCountryCodeUseCase: _loadBanksByCountryCodeUseCase,
      validateAccountUseCase: _validateAccountUseCase,
      validateIBANUseCase: _validateIBANUseCase,
      addNewBeneficiariesUseCase: _addNewBeneficiaryUseCase,
      loadGlobalSettingsUseCase: _loadGlobalSettingsUseCase,
      beneficiaryType: _beneficiaryType,
    );

    when(_loadCountriesUseCase).thenAnswer(
      (_) async => _countriesList,
    );

    when(_loadCustomerUseCase).thenAnswer(
      (_) async => _customer,
    );

    when(_loadAllCurrenciesUseCase).thenAnswer(
      (_) async => _currenciesList,
    );

    when(
      () => _loadGlobalSettingsUseCase(
        codes: _globalSettingsCodes,
      ),
    ).thenAnswer(
      (_) async => _globalSettingList,
    );
  });

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Should start with an empty state.',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      AddBeneficiaryState(
        beneficiaryType: TransferType.international,
        banksPagination: Pagination(limit: 20),
      ),
    ),
  );

  group('Initial loads', _initialLoads);
  group('Adds new beneficiary', _addNewBeneficiary);
  group('Load banks', _loadBanks);
  group('Beneficiary details changes', _detailsChanges);
}

void _initialLoads() {
  final _initialState = AddBeneficiaryState(
    banksPagination: Pagination(limit: _banksPaginationLimit),
    beneficiaryType: TransferType.international,
    busy: true,
    action: AddBeneficiaryAction.none,
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads countries, currencies, customer and settings',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _loadedState,
    ],
    verify: (c) {
      verify(_loadCountriesUseCase).called(1);
      verify(_loadCustomerUseCase).called(1);
      verify(_loadAllCurrenciesUseCase).called(1);
      verify(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).called(1);
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads countries, currencies, empty country for Customer and settings. '
    'Should emit null for selected currency',
    setUp: () {
      when(_loadCustomerUseCase).thenAnswer(
        (_) async => Customer(id: ''),
      );
    },
    build: () {
      return AddBeneficiaryCubit(
        loadCountriesUseCase: _loadCountriesUseCase,
        loadCustomerUseCase: _loadCustomerUseCase,
        loadAvailableCurrenciesUseCase: _loadAllCurrenciesUseCase,
        loadBanksByCountryCodeUseCase: _loadBanksByCountryCodeUseCase,
        validateAccountUseCase: _validateAccountUseCase,
        validateIBANUseCase: _validateIBANUseCase,
        addNewBeneficiariesUseCase: _addNewBeneficiaryUseCase,
        loadGlobalSettingsUseCase: _loadGlobalSettingsUseCase,
        beneficiaryType: _beneficiaryType,
      );
    },
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        beneficiary: Beneficiary(
          nickname: '',
          firstName: '',
          lastName: '',
          middleName: '',
          bankName: '',
          type: _beneficiaryType,
        ),
        countries: _countriesList,
        availableCurrencies: _currenciesList,
        busy: false,
        action: AddBeneficiaryAction.none,
        beneficiarySettings: _globalSettingList,
      ),
    ],
    verify: (c) {
      verify(_loadCountriesUseCase).called(1);
      verify(_loadCustomerUseCase).called(1);
      verify(_loadAllCurrenciesUseCase).called(1);
      verify(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).called(1);
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads countries with exception,'
    'emits state with generic error',
    setUp: () {
      when(
        _loadCountriesUseCase,
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
    verify: (c) => verify(_loadCountriesUseCase).called(1),
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads countries with exception,'
    'emits state with NetException error',
    setUp: () {
      when(
        _loadCountriesUseCase,
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
    verify: (c) => verify(_loadCountriesUseCase).called(1),
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads accounts with exception,'
    'emits state with generic error',
    setUp: () {
      when(
        _loadCustomerUseCase,
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads accounts with exception,'
    'emits state with NetException error',
    setUp: () {
      when(
        _loadCustomerUseCase,
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads currencies with exception,'
    'emits state with generic error',
    setUp: () {
      when(
        _loadAllCurrenciesUseCase,
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads currencies with exception,'
    'emits state with NetException error',
    setUp: () {
      when(
        _loadAllCurrenciesUseCase,
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads global settings with exception,'
    'emits state with generic error',
    setUp: () {
      when(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads global settings with exception,'
    'emits state with NetException error',
    setUp: () {
      when(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _initialState,
      _initialState.copyWith(
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.initAction,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
  );
}

void _loadBanks() {
  setUp(() {
    when(
      () => _loadBanksByCountryCodeUseCase(
        countryCode: _selectedCountry.countryCode!,
        limit: _banksPaginationLimit,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async => _mockedBanksList.take(_banksPaginationLimit).toList(),
    );
  });

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With empty states emits nothing',
    build: () => _cubit,
    act: (c) => c.loadBanks(),
    verify: (c) {
      expect(
        c.state,
        AddBeneficiaryState(
          beneficiaryType: TransferType.international,
          banksPagination: Pagination(limit: 20),
        ),
      );
      verifyNever(
        () => _loadBanksByCountryCodeUseCase(
          countryCode: any(named: 'countryCode'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          query: any(named: 'query'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads banks and emits resulting list',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      selectedCountry: _selectedCountry,
    ),
    act: (c) => c.loadBanks(),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.banks,
        selectedCountry: _selectedCountry,
        busy: true,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.none,
        selectedCountry: _selectedCountry,
        banks: _mockedBanksList.take(_banksPaginationLimit).toList(),
        banksPagination: Pagination(
          limit: _banksPaginationLimit,
          canLoadMore: true,
        ),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads banks by "onChanged()" call with query not being passed '
    'and emits nothing',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      selectedCountry: _selectedCountry,
      bankQuery: 'bankQuery',
    ),
    act: (c) => c.onChanged(),
    expect: () => [],
  );

  final bankQuery = 'bankQuery';
  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads banks by "onChanged()" call '
    'and emits resulting list',
    setUp: () => when(
      () => _loadBanksByCountryCodeUseCase(
        countryCode: _selectedCountry.countryCode!,
        limit: _banksPaginationLimit,
        offset: 0,
        query: bankQuery,
      ),
    ).thenAnswer(
      (_) async => _mockedBanksList.take(_banksPaginationLimit).toList(),
    ),
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      selectedCountry: _selectedCountry,
    ),
    act: (c) => c.onChanged(bankQuery: bankQuery),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        selectedCountry: _selectedCountry,
        bankQuery: bankQuery,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.banks,
        selectedCountry: _selectedCountry,
        busy: true,
        bankQuery: bankQuery,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.none,
        selectedCountry: _selectedCountry,
        banks: _mockedBanksList.take(_banksPaginationLimit).toList(),
        banksPagination: Pagination(
          limit: _banksPaginationLimit,
          canLoadMore: true,
        ),
        bankQuery: bankQuery,
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads more banks(loading of second page), '
    'emits resulting list',
    setUp: () {
      when(
        () => _loadBanksByCountryCodeUseCase(
          countryCode: _selectedCountry.countryCode!,
          limit: _banksPaginationLimit,
          offset: _banksPaginationLimit,
        ),
      ).thenAnswer(
        (_) async => _mockedBanksList
            .skip(_banksPaginationLimit)
            .take(_banksPaginationLimit)
            .toList(),
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.none,
      selectedCountry: _selectedCountry,
      banks: _mockedBanksList.take(_banksPaginationLimit).toList(),
      banksPagination: Pagination(
        limit: _banksPaginationLimit,
        canLoadMore: true,
      ),
    ),
    act: (c) => c.loadBanks(loadMore: true),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.banks,
        selectedCountry: _selectedCountry,
        banks: _mockedBanksList.take(_banksPaginationLimit).toList(),
        banksPagination: Pagination(
          limit: _banksPaginationLimit,
          canLoadMore: true,
        ),
        busy: true,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.none,
        selectedCountry: _selectedCountry,
        banks: _mockedBanksList.take(2 * _banksPaginationLimit).toList(),
        banksPagination: Pagination(
          limit: _banksPaginationLimit,
          canLoadMore: true,
          offset: _banksPaginationLimit,
        ),
      ),
    ],
  );

  final _lastOffset =
      (_banksCount ~/ _banksPaginationLimit) * _banksPaginationLimit;

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads last page , '
    'emits resulting list with "false" for canLoadMore',
    setUp: () {
      when(
        () => _loadBanksByCountryCodeUseCase(
          countryCode: _selectedCountry.countryCode!,
          limit: _banksPaginationLimit,
          offset: _lastOffset + _banksPaginationLimit,
        ),
      ).thenAnswer(
        (_) async => _mockedBanksList
            .skip(_lastOffset)
            .take(_banksPaginationLimit)
            .toList(),
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.none,
      selectedCountry: _selectedCountry,
      banks: _mockedBanksList.take(_lastOffset).toList(),
      banksPagination: Pagination(
        limit: _banksPaginationLimit,
        canLoadMore: true,
        offset: _lastOffset,
      ),
    ),
    act: (c) => c.loadBanks(loadMore: true),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.banks,
        selectedCountry: _selectedCountry,
        banks: _mockedBanksList.take(_lastOffset).toList(),
        banksPagination: Pagination(
            limit: _banksPaginationLimit,
            canLoadMore: true,
            offset: _lastOffset),
        busy: true,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.none,
        selectedCountry: _selectedCountry,
        banks: _mockedBanksList,
        banksPagination: Pagination(
          limit: _banksPaginationLimit,
          canLoadMore: false,
          offset: _lastOffset + _banksPaginationLimit,
        ),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads banks with exception,'
    'emits state with generic error',
    setUp: () {
      when(
        () => _loadBanksByCountryCodeUseCase(
          countryCode: _selectedCountry.countryCode!,
          limit: _banksPaginationLimit,
          offset: 0,
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      selectedCountry: _selectedCountry,
    ),
    act: (c) => c.loadBanks(),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.banks,
        selectedCountry: _selectedCountry,
        busy: true,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.none,
        selectedCountry: _selectedCountry,
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.banks,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads banks with exception,'
    'emits state with NetException error',
    setUp: () {
      when(
        () => _loadBanksByCountryCodeUseCase(
          countryCode: _selectedCountry.countryCode!,
          limit: _banksPaginationLimit,
          offset: 0,
        ),
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      selectedCountry: _selectedCountry,
    ),
    act: (c) => c.loadBanks(),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.banks,
        selectedCountry: _selectedCountry,
        busy: true,
      ),
      _loadedState.copyWith(
        action: AddBeneficiaryAction.none,
        selectedCountry: _selectedCountry,
        busy: false,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.banks,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
  );
}

void _addNewBeneficiary() {
  final _validAccount = '123456789';
  final _invalidAccount = '123';

  final _validIban = 'GB30PAYR00997700004655';
  final _invalidIban = 'GB30';

  final _newBeneficiary = Beneficiary(
    nickname: 'nickname',
    firstName: 'firstName',
    lastName: 'lastName',
    middleName: '',
    bankName: 'bankName',
  );

  final _newBeneficiaryWithValidAccount = _newBeneficiary.copyWith(
    accountNumber: _validAccount,
    routingCode: '111111',
    iban: '',
  );
  final _newBeneficiaryWithInvalidAccount =
      _newBeneficiaryWithValidAccount.copyWith(
    accountNumber: _invalidAccount,
  );

  final _newBeneficiaryWithValidIban = _newBeneficiary.copyWith(
    accountNumber: '',
    routingCode: '',
    iban: _validIban,
  );

  final _newBeneficiaryWithInvalidIban = _newBeneficiary.copyWith(
    accountNumber: '',
    routingCode: '',
    iban: _invalidIban,
  );

  final _newCreatedBeneficiaryWithAccount =
      _newBeneficiaryWithValidAccount.copyWith(
    id: 1,
  );

  final _newCreatedBeneficiaryWithIban = _newBeneficiaryWithValidIban.copyWith(
    id: 1,
  );

  setUp(() {
    /// Stub method for VALID Account validation
    when(
      () => _validateAccountUseCase(
        account: _validAccount,
        allowedCharacters: _allowedCharactersForAccount,
        minAccountChars: _minAccountCharsForAccount,
        maxAccountChars: _maxAccountCharsForAccount,
      ),
    ).thenReturn(true);

    /// Stub method for INVALID Account validation
    when(
      () => _validateAccountUseCase(
        account: _invalidAccount,
        allowedCharacters: _allowedCharactersForAccount,
        minAccountChars: _minAccountCharsForAccount,
        maxAccountChars: _maxAccountCharsForAccount,
      ),
    ).thenReturn(false);

    /// Stub method for VALID IBAN validation
    when(
      () => _validateIBANUseCase(
        iban: _validIban,
        allowedCharacters: _allowedCharactersForIban,
      ),
    ).thenReturn(true);

    /// Stub method for INVALID IBAN validation
    when(
      () => _validateIBANUseCase(
        iban: _invalidIban,
        allowedCharacters: _allowedCharactersForIban,
      ),
    ).thenReturn(false);

    when(
      () => _addNewBeneficiaryUseCase(
        beneficiary: _newBeneficiaryWithValidAccount,
      ),
    ).thenAnswer((_) async => _newCreatedBeneficiaryWithAccount);

    when(
      () => _addNewBeneficiaryUseCase(
        beneficiary: _newBeneficiaryWithValidIban,
      ),
    ).thenAnswer((_) async => _newCreatedBeneficiaryWithIban);
  });

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid account',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithValidAccount,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidAccount,
        action: AddBeneficiaryAction.add,
        busy: true,
      ),
      _loadedState.copyWith(
        beneficiary: _newCreatedBeneficiaryWithAccount,
        action: AddBeneficiaryAction.success,
        busy: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _validateAccountUseCase(
          account: _validAccount,
          allowedCharacters: _allowedCharactersForAccount,
          minAccountChars: _minAccountCharsForAccount,
          maxAccountChars: _maxAccountCharsForAccount,
        ),
      ).called(1);
      verify(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidAccount,
        ),
      ).called(1);
      verifyNever(
        () => _validateIBANUseCase(
          iban: any(named: 'iban'),
          allowedCharacters: any(named: 'allowedCharacters'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid account'
    'emits state with NetException error',
    setUp: () {
      when(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidAccount,
        ),
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithValidAccount,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidAccount,
        action: AddBeneficiaryAction.add,
        busy: true,
      ),
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidAccount,
        busy: false,
        action: AddBeneficiaryAction.none,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.add,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _validateAccountUseCase(
          account: _validAccount,
          allowedCharacters: _allowedCharactersForAccount,
          minAccountChars: _minAccountCharsForAccount,
          maxAccountChars: _maxAccountCharsForAccount,
        ),
      ).called(1);
      verify(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidAccount,
        ),
      ).called(1);
      verifyNever(
        () => _validateIBANUseCase(
          iban: any(named: 'iban'),
          allowedCharacters: any(named: 'allowedCharacters'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid account'
    'emits state with generic error',
    setUp: () {
      when(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidAccount,
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithValidAccount,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidAccount,
        action: AddBeneficiaryAction.add,
        busy: true,
      ),
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidAccount,
        busy: false,
        action: AddBeneficiaryAction.none,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.add,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _validateAccountUseCase(
          account: _validAccount,
          allowedCharacters: _allowedCharactersForAccount,
          minAccountChars: _minAccountCharsForAccount,
          maxAccountChars: _maxAccountCharsForAccount,
        ),
      ).called(1);
      verify(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidAccount,
        ),
      ).called(1);
      verifyNever(
        () => _validateIBANUseCase(
          iban: any(named: 'iban'),
          allowedCharacters: any(named: 'allowedCharacters'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With invalid account',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithInvalidAccount,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithInvalidAccount,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.add,
            errorStatus: AddBeneficiaryErrorStatus.invalidAccount,
          ),
        },
      ),
    ],
    verify: (c) {
      verify(
        () => _validateAccountUseCase(
          account: _invalidAccount,
          allowedCharacters: _allowedCharactersForAccount,
          minAccountChars: _minAccountCharsForAccount,
          maxAccountChars: _maxAccountCharsForAccount,
        ),
      ).called(1);
      verifyNever(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithInvalidAccount,
        ),
      );
      verifyNever(
        () => _validateIBANUseCase(
          iban: any(named: 'iban'),
          allowedCharacters: any(named: 'allowedCharacters'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid IBAN',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithValidIban,
      selectedCurrency: _currencyEur,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidIban,
        action: AddBeneficiaryAction.add,
        busy: true,
        selectedCurrency: _currencyEur,
      ),
      _loadedState.copyWith(
        beneficiary: _newCreatedBeneficiaryWithIban,
        action: AddBeneficiaryAction.success,
        busy: false,
        selectedCurrency: _currencyEur,
      ),
    ],
    verify: (c) {
      verify(
        () => _validateIBANUseCase(
          iban: _validIban,
          allowedCharacters: _allowedCharactersForIban,
        ),
      ).called(1);
      verify(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidIban,
        ),
      ).called(1);
      verifyNever(
        () => _validateAccountUseCase(
          account: any(named: 'account'),
          allowedCharacters: any(named: 'allowedCharacters'),
          maxAccountChars: any(named: 'maxAccountChars'),
          minAccountChars: any(named: 'minAccountChars'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid IBAN, '
    'emits state with NetException error',
    setUp: () {
      when(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidIban,
        ),
      ).thenAnswer(
        (_) async => throw _netException,
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithValidIban,
      selectedCurrency: _currencyEur,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidIban,
        action: AddBeneficiaryAction.add,
        busy: true,
        selectedCurrency: _currencyEur,
      ),
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidIban,
        busy: false,
        selectedCurrency: _currencyEur,
        action: AddBeneficiaryAction.none,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.add,
            errorStatus: AddBeneficiaryErrorStatus.network,
            code: _netException.code,
            message: _netException.message,
          )
        },
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _validateIBANUseCase(
          iban: _validIban,
          allowedCharacters: _allowedCharactersForIban,
        ),
      ).called(1);
      verify(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidIban,
        ),
      ).called(1);
      verifyNever(
        () => _validateAccountUseCase(
          account: any(named: 'account'),
          allowedCharacters: any(named: 'allowedCharacters'),
          maxAccountChars: any(named: 'maxAccountChars'),
          minAccountChars: any(named: 'minAccountChars'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid IBAN, '
    'emits state with generic error',
    setUp: () {
      when(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidIban,
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );
    },
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithValidIban,
      selectedCurrency: _currencyEur,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidIban,
        action: AddBeneficiaryAction.add,
        busy: true,
        selectedCurrency: _currencyEur,
      ),
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithValidIban,
        busy: false,
        selectedCurrency: _currencyEur,
        action: AddBeneficiaryAction.none,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.add,
            errorStatus: AddBeneficiaryErrorStatus.generic,
          )
        },
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _validateIBANUseCase(
          iban: _validIban,
          allowedCharacters: _allowedCharactersForIban,
        ),
      ).called(1);
      verify(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithValidIban,
        ),
      ).called(1);
      verifyNever(
        () => _validateAccountUseCase(
          account: any(named: 'account'),
          allowedCharacters: any(named: 'allowedCharacters'),
          maxAccountChars: any(named: 'maxAccountChars'),
          minAccountChars: any(named: 'minAccountChars'),
        ),
      );
    },
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With invalid IBAN',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      beneficiary: _newBeneficiaryWithInvalidIban,
      selectedCurrency: _currencyEur,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _loadedState.copyWith(
        beneficiary: _newBeneficiaryWithInvalidIban,
        selectedCurrency: _currencyEur,
        errors: {
          AddBeneficiaryError(
            action: AddBeneficiaryAction.add,
            errorStatus: AddBeneficiaryErrorStatus.invalidIBAN,
          ),
        },
      ),
    ],
    verify: (c) {
      verify(
        () => _validateIBANUseCase(
          iban: _invalidIban,
          allowedCharacters: _allowedCharactersForIban,
        ),
      ).called(1);
      verifyNever(
        () => _addNewBeneficiaryUseCase(
          beneficiary: _newBeneficiaryWithInvalidIban,
        ),
      );
      verifyNever(
        () => _validateAccountUseCase(
          account: any(named: 'account'),
          allowedCharacters: any(named: 'allowedCharacters'),
          maxAccountChars: any(named: 'maxAccountChars'),
          minAccountChars: any(named: 'minAccountChars'),
        ),
      );
    },
  );
}

void _detailsChanges() {
  final firstName = 'firstName';
  final newFirstName = '${firstName}A';
  final lastName = 'lastName';
  final newLastName = '${lastName}A';
  final nickname = 'nickname';
  final newNickname = '${nickname}A';
  final address1 = 'address1';
  final newAddress1 = '${address1}A';
  final address2 = 'address2';
  final newAddress2 = '${address2}A';
  final address3 = 'address3';
  final newAddress3 = '${address3}A';
  final account = 'account';
  final newAccount = '${account}A';
  final routingCode = 'routingCode';
  final newRoutingCode = '${routingCode}A';
  final iban = 'iban';
  final newIban = '${iban}A';
  final newCurrency = _currenciesList.first;

  final editedBeneficiary = Beneficiary(
    nickname: 'nickname',
    firstName: firstName,
    lastName: lastName,
    bankName: '',
    currency: _currencyGbp.code,
    type: TransferType.international,
    middleName: '',
    address1: address1,
    address2: address2,
    address3: address3,
    accountNumber: account,
    routingCode: routingCode,
    iban: iban,
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new first name',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onFirstNameChange(newFirstName),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(firstName: newFirstName),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new last name',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onLastNameChange(newLastName),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(lastName: newLastName),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new nickname',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onNicknameChange(newNickname),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(nickname: newNickname),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new address 1',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onAddress1Change(newAddress1),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(address1: newAddress1),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new address 2',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onAddress2Change(newAddress2),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(address2: newAddress2),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new address 3',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onAddress3Change(newAddress3),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(address3: newAddress3),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new account number',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onAccountChange(newAccount),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(accountNumber: newAccount),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new sort code',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onRoutingCodeChange(newRoutingCode),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(routingCode: newRoutingCode),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new IBAN',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onIbanChange(newIban),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(iban: newIban),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new currency',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onCurrencyChanged(newCurrency),
    expect: () => [
      _loadedState.copyWith(
        selectedCurrency: newCurrency,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(currency: newCurrency.code),
      ),
    ],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with beneficiary new selected bank',
    build: () => _cubit,
    seed: () => _loadedState.copyWith(
      action: AddBeneficiaryAction.editAction,
      beneficiary: editedBeneficiary,
    ),
    act: (c) => c.onBankChanged(_mockedSelectedBank),
    expect: () => [
      _loadedState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary.copyWith(bank: _mockedSelectedBank),
      ),
    ],
  );
}
