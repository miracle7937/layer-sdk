import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadCountriesUseCase extends Mock implements LoadCountriesUseCase {}

class MockGetCustomerAccountsUseCase extends Mock
    implements GetCustomerAccountsUseCase {}

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

class MockGlobalSetting extends Mock implements GlobalSetting {}

class MockBank extends Mock implements Bank {}

final _loadCountriesUseCase = MockLoadCountriesUseCase();
final _getCustomerAccountsUseCase = MockGetCustomerAccountsUseCase();
final _loadAllCurrenciesUseCase = MockLoadAllCurrenciesUseCase();
final _loadBanksByCountryCodeUseCase = MockLoadBanksByCountryCodeUseCase();
final _validateAccountUseCase = MockValidateAccountUseCase();
final _validateIBANUseCase = MockValidateIBANUseCase();
final _addNewBeneficiaryUseCase = MockAddNewBeneficiaryUseCase();
final _loadGlobalSettingsUseCase = MockLoadGlobalSettingsUseCase();

final _countriesList = [
  Country(countryCode: 'GB'),
  Country(countryCode: 'IE'),
];
final _selectedCountry = _countriesList.first;

final _banksPaginationLimit = 20;
final _mockedBanksList =
    List.generate(_banksPaginationLimit, (index) => MockBank());
final _mockedSelectedBank = _mockedBanksList.first;

final _accountsList = [
  Account(currency: 'GBP'),
  Account(currency: 'USD'),
];

final _selectedCurrency = Currency(code: 'GBP');
final _currenciesList = [
  Currency(code: 'EUR'),
  _selectedCurrency,
];
final _globalSettingsCodes = [
  'benef_iban_allowed_characters',
  'benef_acc_num_allowed_characters',
  'benef_acc_num_minimum_characters',
  'benef_acc_num_maximum_characters',
];
final _mockedGlobalSettingList =
    List.generate(10, (index) => MockGlobalSetting());

late AddBeneficiaryCubit _cubit;

final _beneficiaryType = TransferType.international;

final _initialState = AddBeneficiaryState(
  banksPagination: Pagination(limit: _banksPaginationLimit),
  beneficiaryType: _beneficiaryType,
  beneficiary: Beneficiary(
    nickname: '',
    firstName: '',
    lastName: '',
    middleName: '',
    bankName: '',
    currency: _selectedCurrency.code,
    type: _beneficiaryType,
  ),
  countries: _countriesList,
  selectedCurrency: _selectedCurrency,
  availableCurrencies: _currenciesList,
  beneficiarySettings: _mockedGlobalSettingList,
  action: AddBeneficiaryAction.initAction,
);

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _cubit = AddBeneficiaryCubit(
      loadCountriesUseCase: _loadCountriesUseCase,
      getCustomerAccountsUseCase: _getCustomerAccountsUseCase,
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

    when(_getCustomerAccountsUseCase).thenAnswer(
      (_) async => _accountsList,
    );

    when(_loadAllCurrenciesUseCase).thenAnswer(
      (_) async => _currenciesList,
    );

    when(
      () => _loadGlobalSettingsUseCase(
        codes: _globalSettingsCodes,
      ),
    ).thenAnswer(
      (_) async => _mockedGlobalSettingList,
    );

    when(
      () => _loadBanksByCountryCodeUseCase(
        countryCode: _selectedCountry.countryCode!,
        limit: _banksPaginationLimit,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async => _mockedBanksList,
    );
  });

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Should start with an empty state.',
    build: () => _cubit,
    expect: () => [],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads countries, currencies, accounts and settings',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      AddBeneficiaryState(
        banksPagination: Pagination(limit: _banksPaginationLimit),
        beneficiaryType: TransferType.international,
        busy: true,
        action: AddBeneficiaryAction.none,
      ),
      _initialState,
    ],
    verify: (c) {
      verify(_loadCountriesUseCase).called(1);
      verify(_getCustomerAccountsUseCase).called(1);
      verify(_loadAllCurrenciesUseCase).called(1);
      verify(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).called(1);
    },
  );
  //
  // group('Selecting new country', () {
  //   blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
  //     'Emits state with new selected country',
  //     build: () => _cubit,
  //     seed: () => _initialState,
  //     act: (c) => c.onCountryChanged(_selectedCountry),
  //     expect: () => [
  //       _initialState.copyWith(
  //         action: AddBeneficiaryAction.editAction,
  //         selectedCountry: _selectedCountry,
  //       ),
  //     ],
  //   );
  // });

  group('Load banks', () {
    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'With empty states emits nothing',
      build: () => _cubit,
      act: (c) => c.loadBanks(),
      expect: () => [],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Loads banks and emits resulting list',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        selectedCountry: _selectedCountry,
      ),
      act: (c) => c.loadBanks(),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.banks,
          selectedCountry: _selectedCountry,
          busy: true,
        ),
        _initialState.copyWith(
          action: AddBeneficiaryAction.none,
          selectedCountry: _selectedCountry,
          banks: _mockedBanksList,
          banksPagination: Pagination(
            limit: _banksPaginationLimit,
            canLoadMore: true,
          ),
        ),
      ],
    );
  });

  group('GetCustomerAccountsUseCase returns empty list', () {
    final _loadCountriesUseCase = MockLoadCountriesUseCase();
    final _getCustomerAccountsUseCase = MockGetCustomerAccountsUseCase();
    final _loadAllCurrenciesUseCase = MockLoadAllCurrenciesUseCase();
    final _loadBanksByCountryCodeUseCase = MockLoadBanksByCountryCodeUseCase();
    final _validateAccountUseCase = MockValidateAccountUseCase();
    final _validateIBANUseCase = MockValidateIBANUseCase();
    final _addNewBeneficiaryUseCase = MockAddNewBeneficiaryUseCase();
    final _loadGlobalSettingsUseCase = MockLoadGlobalSettingsUseCase();

    setUp(() {
      when(_loadCountriesUseCase).thenAnswer(
        (_) async => _countriesList,
      );

      when(_getCustomerAccountsUseCase).thenAnswer(
        (_) async => <Account>[],
      );

      when(_loadAllCurrenciesUseCase).thenAnswer(
        (_) async => _currenciesList,
      );

      when(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).thenAnswer(
        (_) async => _mockedGlobalSettingList,
      );
    });

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Loads countries, currencies, empty accounts and settings.'
      'Should emit null for selected currency',
      build: () {
        return AddBeneficiaryCubit(
          loadCountriesUseCase: _loadCountriesUseCase,
          getCustomerAccountsUseCase: _getCustomerAccountsUseCase,
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
        AddBeneficiaryState(
          banksPagination: Pagination(limit: _banksPaginationLimit),
          beneficiaryType: _beneficiaryType,
          busy: true,
          action: AddBeneficiaryAction.none,
        ),
        AddBeneficiaryState(
          banksPagination: Pagination(limit: _banksPaginationLimit),
          beneficiaryType: _beneficiaryType,
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
          action: AddBeneficiaryAction.initAction,
          beneficiarySettings: _mockedGlobalSettingList,
        ),
      ],
      verify: (c) {
        verify(_loadCountriesUseCase).called(1);
        verify(_getCustomerAccountsUseCase).called(1);
        verify(_loadAllCurrenciesUseCase).called(1);
        verify(
          () => _loadGlobalSettingsUseCase(
            codes: _globalSettingsCodes,
          ),
        ).called(1);
      },
    );
  });

  group('Beneficiary details changes', () {
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
      currency: _selectedCurrency.code,
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
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onFirstNameChange(newFirstName),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(firstName: newFirstName),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new last name',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onLastNameChange(newLastName),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(lastName: newLastName),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new nickname',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onNicknameChange(newNickname),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(nickname: newNickname),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new address 1',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAddress1Change(newAddress1),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(address1: newAddress1),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new address 2',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAddress2Change(newAddress2),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(address2: newAddress2),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new address 3',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAddress3Change(newAddress3),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(address3: newAddress3),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new account number',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAccountChange(newAccount),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(accountNumber: newAccount),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new sort code',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onRoutingCodeChange(newRoutingCode),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(routingCode: newRoutingCode),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new IBAN',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onIbanChange(newIban),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(iban: newIban),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new currency',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onCurrencyChanged(newCurrency),
      expect: () => [
        _initialState.copyWith(
          selectedCurrency: newCurrency,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(currency: newCurrency.code),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new selected bank',
      build: () => _cubit,
      seed: () => _initialState.copyWith(
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onBankChanged(_mockedSelectedBank),
      expect: () => [
        _initialState.copyWith(
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(bank: _mockedSelectedBank),
        ),
      ],
    );
  });
}
