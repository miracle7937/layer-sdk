import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:layer_sdk/data_layer/errors.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadUserByUsernameUseCase extends Mock
    implements LoadUserByUsernameUseCase {}

class MockLoadGlobalSettingsUseCase extends Mock
    implements LoadGlobalSettingsUseCase {}

class MockCountryWithPhoneCodeWrapper extends Mock
    implements CountryWithPhoneCodeWrapper {}

class MockGlobalSettingCubit extends Mock implements GlobalSettingCubit {}

late MockGlobalSettingCubit _mockGlobalSettingCubit;

final _usernameMinChars = 6;
final _usernameMaxChars = 16;
final _maxFileSize = 100;

final _initialState = NewAgentInformationStepState(
  usernameMinChars: _usernameMinChars,
  usernameMaxChars: _usernameMaxChars,
  maxFileSize: _maxFileSize,
);

final _username = 'username';
final _firstName = 'firstName';
final _lastName = 'lastName';
final _phoneCode = '+380';
final _numberWithoutCode = '952222222';
final _email = 'dd@kk.mm';

void main() {
  EquatableConfig.stringify = true;

  final gs1 = GlobalSetting(
    code: 'minimum_characters',
    module: 'customer_username',
    value: _usernameMinChars,
    type: GlobalSettingType.int,
  );
  final gs2 = GlobalSetting(
    code: 'maximum_characters',
    module: 'customer_username',
    value: _usernameMaxChars,
    type: GlobalSettingType.int,
  );

  final gs3 = GlobalSetting(
    code: 'image_size',
    module: 'customer_username',
    value: _maxFileSize,
    type: GlobalSettingType.int,
  );

  setUpAll(() async {
    _mockGlobalSettingCubit = MockGlobalSettingCubit();

    when(
      () => _mockGlobalSettingCubit.load(module: 'customer_username'),
    ).thenAnswer(
      (_) async {
        // mockGlobalSettingCubit.em;
      },
    );

    when(
      () => _mockGlobalSettingCubit.stream,
    ).thenAnswer(
      (_) async* {
        yield GlobalSettingState(
          busy: false,
          settings: UnmodifiableListView([gs1, gs2, gs3]),
        );
      },
    );

    when(
      () => _mockGlobalSettingCubit.load(module: 'customer_username'),
    ).thenAnswer(
      (_) async {
        // mockGlobalSettingCubit.em;
      },
    );
  });

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Starts with loading and emitting global settings',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    verify: (c) => expect(
      c.state,
      _initialState,
    ),
  );

  final user = User(
    id: 'user.id',
    username: 'user.username',
    firstName: 'user.firstName',
    lastName: 'user.lastName',
    email: 'user.email',
    mobileNumber: '$_phoneCode$_numberWithoutCode',
    motherName: 'user.motherName',
    branch: 'user.branch',
    maritalStatus: CustomerMaritalStatus.single,
    gender: CustomerGender.male,
    agentCustomerId: 'user.agentCustomerId',
    address: 'user.address',
    dob: DateTime.now(),
  );

  late MockCountryWithPhoneCodeWrapper countryWithPhoneCodeWrapper;

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Starts with passed user, loading and emitting global settings',
    setUp: () {
      countryWithPhoneCodeWrapper = MockCountryWithPhoneCodeWrapper();

      when(
        () => countryWithPhoneCodeWrapper.getCountryDataByPhone(
          _phoneCode.replaceFirst('+', '') + _numberWithoutCode,
        ),
      ).thenReturn(
        CountryWithPhoneCode(
          phoneCode: _phoneCode.replaceFirst('+', ''),
          countryCode: '',
          exampleNumberMobileNational: '',
          exampleNumberFixedLineNational: '',
          phoneMaskMobileNational: '',
          phoneMaskFixedLineNational: '',
          exampleNumberMobileInternational: '',
          exampleNumberFixedLineInternational: '',
          phoneMaskMobileInternational: '',
          phoneMaskFixedLineInternational: '',
          countryName: '',
        ),
      );
    },
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
      countryWithPhoneCodeWrapper: countryWithPhoneCodeWrapper,
      user: user,
    ),
    verify: (c) => expect(
      c.state,
      _initialState.copyWith(
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        dialCode: _phoneCode.replaceAll('+', ''),
        mobileNumber: _numberWithoutCode,
        motherName: user.motherName,
        completed: true,
        branchId: user.branch,
        maritalStatus: user.maritalStatus,
        gender: user.gender,
        customerId: user.agentCustomerId,
        address: user.address,
        dob: user.dob,
        action: StepsStateAction.initAction,
      ),
    ),
  );

  group('Username changes', usernameChanges);
  group('First name changes', firstNameChanges);
  group('Last name changes', lastNameChanges);
  group('Mobile number changes', mobileNumberChanges);
  group('Email changes', emailChanges);
  group('Continue action', onContinue);

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of dial code, '
    'emits new dial code',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onDialCodeChange(_phoneCode);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        dialCode: _phoneCode,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final motherName = 'motherName';

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of mother name, '
    'emits new mother name',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onMotherNameChange(motherName);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        motherName: motherName,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final branchId = 'branchId';

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of branch, '
    'emits new branch id',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onBranchChanged(branchId);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        branchId: branchId,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final maritalStatus = CustomerMaritalStatus.married;

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of marital status, '
    'emits new marital status',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onMaritalStatusChanged(maritalStatus);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        maritalStatus: maritalStatus,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final gender = CustomerGender.male;

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of gender, '
    'emits new gender',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onGenderChanged(gender);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        gender: gender,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final customerId = 'customerId';

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of customer id, '
    'emits new customer id',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onCustomerIdChanged(customerId);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        customerId: customerId,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final address = 'address';

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of address, '
    'emits new address',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onAddressChanged(address);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        address: address,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final dob = DateTime.now();

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of dob, '
    'emits new dob',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onDOBChanged(dob);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        dob: dob,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final image = 'image';

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of profile image, '
    'emits new profile image',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onImageFileChanged(image);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        image: image,
        action: StepsStateAction.editAction,
      ),
    ],
  );
}

void usernameChanges() {
  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of username, '
    'emits new username',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onUsernameChange(_username);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        username: _username,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Empty username, '
    'emits empty error',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onUsernameChange('');
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        username: '',
        action: StepsStateAction.editAction,
        usernameError: UsernameErrorType.empty,
      ),
    ],
  );

  final shortUsername =
      List.generate(_usernameMinChars - 1, (index) => 'a').join();

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Not valid, short username, '
    'emits min chars error',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onUsernameChange(shortUsername);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        username: shortUsername,
        action: StepsStateAction.editAction,
        usernameError: UsernameErrorType.minChars,
      ),
    ],
  );

  final longUsername =
      List.generate(_usernameMaxChars + 1, (index) => 'a').join();

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Not valid, long username, '
    'emits max chars error',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onUsernameChange(longUsername);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        username: longUsername,
        action: StepsStateAction.editAction,
        usernameError: UsernameErrorType.maxChars,
      ),
    ],
  );
}

void firstNameChanges() {
  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of first name, '
    'emits new first name',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onFirstNameChange(_firstName);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        firstName: _firstName,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of first name when error displayed, '
    'emits new first name',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    seed: () => _initialState.copyWith(
      firstNameErrorDisplayed: true,
      action: StepsStateAction.editAction,
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onFirstNameChange(_firstName);
    },
    expect: () => [
      // _initialState,
      _initialState.copyWith(
        firstName: _firstName,
        action: StepsStateAction.editAction,
      ),
    ],
  );
}

void lastNameChanges() {
  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of last name, '
    'emits new last name',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onLastNameChange(_lastName);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        lastName: _lastName,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of last name when error displayed, '
    'emits new last name',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    seed: () => _initialState.copyWith(
      lastNameErrorDisplayed: true,
      action: StepsStateAction.editAction,
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onLastNameChange(_lastName);
    },
    expect: () => [
      // _initialState,
      _initialState.copyWith(
        lastName: _lastName,
        action: StepsStateAction.editAction,
      ),
    ],
  );
}

void mobileNumberChanges() {
  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of mobile number, '
    'emits new mobile number',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onMobileNumberChange(_numberWithoutCode);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        mobileNumber: _numberWithoutCode,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Changing of mobile number when error displayed, '
    'emits new mobile number',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    seed: () => _initialState.copyWith(
      mobileNumberErrorDisplayed: true,
      action: StepsStateAction.editAction,
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onMobileNumberChange(_numberWithoutCode);
    },
    expect: () => [
      _initialState.copyWith(
        mobileNumber: _numberWithoutCode,
        action: StepsStateAction.editAction,
      ),
    ],
  );
}

void emailChanges() {
  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Editing of email, '
    'emits new email',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onEmailChange(_email);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        email: _email,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Empty email entered, '
    'emits empty error',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onEmailChange('');
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        emailError: EmailErrorType.empty,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  final invalidEmail = 'ww@';

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Invalid email entered, '
    'emits new email with error',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: MockLoadUserByUsernameUseCase(),
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onEmailChange(invalidEmail);
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        email: invalidEmail,
        emailError: EmailErrorType.invalid,
        action: StepsStateAction.editAction,
      ),
    ],
  );
}

void onContinue() {
  late MockLoadUserByUsernameUseCase mockLoadUserByUsernameUseCase;

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Successful onContinue',
    setUp: () {
      mockLoadUserByUsernameUseCase = MockLoadUserByUsernameUseCase();
      when(
        () => mockLoadUserByUsernameUseCase(_username),
      ).thenThrow(UserNotFoundException());
    },
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: mockLoadUserByUsernameUseCase,
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    seed: () => _initialState.copyWith(
      username: _username,
      firstName: _firstName,
      lastName: _lastName,
      mobileNumber: _numberWithoutCode,
      email: _email,
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onContinue();
    },
    expect: () => [
      _initialState.copyWith(
        username: _username,
        firstName: _firstName,
        lastName: _lastName,
        mobileNumber: _numberWithoutCode,
        email: _email,
        action: StepsStateAction.continueAction,
      ),
      _initialState.copyWith(
        username: _username,
        firstName: _firstName,
        lastName: _lastName,
        mobileNumber: _numberWithoutCode,
        email: _email,
        action: StepsStateAction.continueAction,
        completed: true,
      ),
    ],
  );

  blocTest<NewAgentInformationStepCubit, NewAgentInformationStepState>(
    'Trying to continue with empty required fields, '
    'emits errors',
    build: () => NewAgentInformationStepCubit(
      globalSettingCubit: _mockGlobalSettingCubit,
      loadUserByUsernameUseCase: mockLoadUserByUsernameUseCase,
      validateEmailUseCase: ValidateEmailUseCase(),
    ),
    act: (c) async {
      await Future.delayed(Duration.zero);
      c.onContinue();
    },
    expect: () => [
      _initialState,
      _initialState.copyWith(
        usernameError: UsernameErrorType.empty,
        firstNameErrorDisplayed: true,
        lastNameErrorDisplayed: true,
        mobileNumberErrorDisplayed: true,
        emailError: EmailErrorType.empty,
        action: StepsStateAction.continueAction,
      ),
    ],
  );
}
