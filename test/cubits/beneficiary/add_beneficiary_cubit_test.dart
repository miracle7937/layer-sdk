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

final _currencyEur = Currency(code: 'EUR');
final _currencyGbp = Currency(code: 'GBP');
final _currenciesList = [
  _currencyEur,
  _currencyGbp,
];

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

final _initialState = AddBeneficiaryState(
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
  action: AddBeneficiaryAction.initAction,
);

final String _validAccount = '123456789';

final String _validIban = 'GB30PAYR00997700004655';

final _newBeneficiary = Beneficiary(
  nickname: 'nickname',
  firstName: 'firstName',
  lastName: 'lastName',
  middleName: '',
  bankName: 'bankName',
);

final _newValidBeneficiaryWithAccount = _newBeneficiary.copyWith(
  accountNumber: _validAccount,
  routingCode: '111111',
  iban: '',
);

final _newValidBeneficiaryWithIban = _newBeneficiary.copyWith(
  accountNumber: '',
  routingCode: '',
  iban: _validIban,
);

final _newCreatedBeneficiaryWithAccount =
    _newValidBeneficiaryWithAccount.copyWith(
  id: 1,
);

final _newCreatedBeneficiaryWithIban = _newValidBeneficiaryWithIban.copyWith(
  id: 1,
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
      (_) async => _globalSettingList,
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

    when(
      () => _validateAccountUseCase(
        account: _validAccount,
        allowedCharacters: _allowedCharactersForAccount,
        minAccountChars: _minAccountCharsForAccount,
        maxAccountChars: _maxAccountCharsForAccount,
      ),
    ).thenReturn(true);

    when(
      () => _validateIBANUseCase(
        iban: _validIban,
        allowedCharacters: _allowedCharactersForIban,
      ),
    ).thenReturn(true);

    when(
      () => _addNewBeneficiaryUseCase(
        beneficiary: _newValidBeneficiaryWithAccount,
      ),
    ).thenAnswer((_) async => _newCreatedBeneficiaryWithAccount);
    when(
      () => _addNewBeneficiaryUseCase(
        beneficiary: _newValidBeneficiaryWithIban,
      ),
    ).thenAnswer((_) async => _newCreatedBeneficiaryWithIban);
  });

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Should start with an empty state.',
    build: () => _cubit,
    expect: () => [],
  );

  group('Initial loads', _initialLoads);
  group('Adds new beneficiary', _addNewBeneficiary);
  group('Load banks', _loadBanks);
  group('Beneficiary details changes', _detailsChanges);
}

void _initialLoads() {
  final _getCustomerAccountsUseCaseEmpty = MockGetCustomerAccountsUseCase();

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

  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'Loads countries, currencies, empty accounts list and settings.'
    'Should emit null for selected currency',
    setUp: () {
      when(_getCustomerAccountsUseCaseEmpty).thenAnswer(
        (_) async => <Account>[],
      );
    },
    build: () {
      return AddBeneficiaryCubit(
        loadCountriesUseCase: _loadCountriesUseCase,
        getCustomerAccountsUseCase: _getCustomerAccountsUseCaseEmpty,
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
        beneficiarySettings: _globalSettingList,
      ),
    ],
    verify: (c) {
      verify(_loadCountriesUseCase).called(1);
      verify(_getCustomerAccountsUseCaseEmpty).called(1);
      verify(_loadAllCurrenciesUseCase).called(1);
      verify(
        () => _loadGlobalSettingsUseCase(
          codes: _globalSettingsCodes,
        ),
      ).called(1);
    },
  );
}

void _loadBanks() {
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
}

void _addNewBeneficiary() {
  blocTest<AddBeneficiaryCubit, AddBeneficiaryState>(
    'With valid account',
    build: () => _cubit,
    seed: () => _initialState.copyWith(
      beneficiary: _newValidBeneficiaryWithAccount,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _initialState.copyWith(
        beneficiary: _newValidBeneficiaryWithAccount,
        action: AddBeneficiaryAction.add,
        busy: true,
      ),
      _initialState.copyWith(
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
          beneficiary: _newValidBeneficiaryWithAccount,
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
    'With valid IBAN',
    build: () => _cubit,
    seed: () => _initialState.copyWith(
      beneficiary: _newValidBeneficiaryWithIban,
      selectedCurrency: _currencyEur,
    ),
    act: (c) => c.onAdd(),
    expect: () => [
      _initialState.copyWith(
        beneficiary: _newValidBeneficiaryWithIban,
        action: AddBeneficiaryAction.add,
        busy: true,
        selectedCurrency: _currencyEur,
      ),
      _initialState.copyWith(
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
          beneficiary: _newValidBeneficiaryWithIban,
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
}
