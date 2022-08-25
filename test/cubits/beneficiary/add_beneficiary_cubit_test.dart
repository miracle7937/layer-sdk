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

class MockCountry extends Mock implements Country {}

class MockAccount extends Mock implements Account {}

class MockCurrency extends Mock implements Currency {}

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

final _mockedCountriesList = List.generate(10, (index) => MockCountry());
final _mockedSelectedCountry = _mockedCountriesList.first;

final _mockedBanksList = List.generate(10, (index) => MockBank());
final _mockedSelectedBank = _mockedBanksList.first;

final _mockedAccountsList = [
  Account(currency: 'GBP'),
  Account(currency: 'USD'),
];

final _selectedCurrency = Currency(code: 'GBP');
final _mockedCurrenciesList = [
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
      (_) async => _mockedCountriesList,
    );

    when(_getCustomerAccountsUseCase).thenAnswer(
      (_) async => _mockedAccountsList,
    );

    when(_loadAllCurrenciesUseCase).thenAnswer(
      (_) async => _mockedCurrenciesList,
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
        countryCode: _mockedSelectedCountry.countryCode!,
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
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        busy: true,
        action: AddBeneficiaryAction.none,
      ),
      AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        beneficiary: Beneficiary(
          nickname: '',
          firstName: '',
          lastName: '',
          middleName: '',
          bankName: '',
          currency: _selectedCurrency.code,
          type: TransferType.international,
        ),
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
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

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads banks with empty states emits nothing',
    build: () => _cubit,
    act: (c) => c.loadBanks(),
    expect: () => [],
  );

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Emits state with new selected country',
    build: () => _cubit,
    seed: () => AddBeneficiaryState(
      banksPagination: Pagination(limit: 20),
      beneficiaryType: TransferType.international,
      countries: _mockedCountriesList,
      selectedCurrency: _selectedCurrency,
      availableCurrencies: _mockedCurrenciesList,
      beneficiarySettings: _mockedGlobalSettingList,
      action: AddBeneficiaryAction.initAction,
    ),
    act: (c) => c.onCountryChanged(_mockedSelectedCountry),
    expect: () => [
      AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        selectedCountry: _mockedSelectedCountry,
      ),
    ],
  );

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
        (_) async => _mockedCountriesList,
      );

      when(_getCustomerAccountsUseCase).thenAnswer(
        (_) async => <Account>[],
      );

      when(_loadAllCurrenciesUseCase).thenAnswer(
        (_) async => _mockedCurrenciesList,
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
          banksPagination: Pagination(limit: 20),
          beneficiaryType: _beneficiaryType,
          busy: true,
          action: AddBeneficiaryAction.none,
        ),
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: _beneficiaryType,
          beneficiary: Beneficiary(
            nickname: '',
            firstName: '',
            lastName: '',
            middleName: '',
            bankName: '',
            type: _beneficiaryType,
          ),
          countries: _mockedCountriesList,
          availableCurrencies: _mockedCurrenciesList,
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
    final newCurrency = _mockedCurrenciesList.first;
    // final newBank =

    final editedBeneficiary = Beneficiary(
      nickname: 'nickname',
      firstName: firstName,
      lastName: lastName,
      bankName: 'e',
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
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onFirstNameChange(newFirstName),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(firstName: newFirstName),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new last name',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onLastNameChange(newLastName),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(lastName: newLastName),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new nickname',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onNicknameChange(newNickname),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(nickname: newNickname),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new address 1',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAddress1Change(newAddress1),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(address1: newAddress1),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new address 2',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAddress2Change(newAddress2),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(address2: newAddress2),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new address 3',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAddress3Change(newAddress3),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(address3: newAddress3),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new account number',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onAccountChange(newAccount),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(accountNumber: newAccount),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new sort code',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onRoutingCodeChange(newRoutingCode),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(routingCode: newRoutingCode),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new IBAN',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onIbanChange(newIban),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: _selectedCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(iban: newIban),
        ),
      ],
    );

    blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
      'Emits state with beneficiary new currency',
      build: () => _cubit,
      seed: () => AddBeneficiaryState(
        banksPagination: Pagination(limit: 20),
        beneficiaryType: TransferType.international,
        countries: _mockedCountriesList,
        selectedCurrency: _selectedCurrency,
        availableCurrencies: _mockedCurrenciesList,
        beneficiarySettings: _mockedGlobalSettingList,
        action: AddBeneficiaryAction.editAction,
        beneficiary: editedBeneficiary,
      ),
      act: (c) => c.onCurrencyChanged(newCurrency),
      expect: () => [
        AddBeneficiaryState(
          banksPagination: Pagination(limit: 20),
          beneficiaryType: TransferType.international,
          countries: _mockedCountriesList,
          selectedCurrency: newCurrency,
          availableCurrencies: _mockedCurrenciesList,
          beneficiarySettings: _mockedGlobalSettingList,
          action: AddBeneficiaryAction.editAction,
          beneficiary: editedBeneficiary.copyWith(currency: newCurrency.code),
        ),
      ],
    );
  });
}
