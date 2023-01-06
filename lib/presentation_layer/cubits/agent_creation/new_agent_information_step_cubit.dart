import 'dart:async';

import 'package:collection/collection.dart';

import '../../../data_layer/errors.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../utils.dart';

/// A cubit responsible for information step of Agent's creation process.
class NewAgentInformationStepCubit
    extends StepCubit<NewAgentInformationStepState> {
  late StreamSubscription _streamSubscription;

  final LoadUserByUsernameUseCase _loadUserByUsernameUseCase;

  final ValidateEmailUseCase _validateEmailUseCase;

  /// The wrapper for `flutter_libphonenumber` library.
  final CountryWithPhoneCodeWrapper _countryWithPhoneCodeWrapper;

  /// Creates new [NewAgentInformationStepCubit]
  NewAgentInformationStepCubit({
    required GlobalSettingCubit globalSettingCubit,
    required LoadUserByUsernameUseCase loadUserByUsernameUseCase,
    required ValidateEmailUseCase validateEmailUseCase,
    CountryWithPhoneCodeWrapper? countryWithPhoneCodeWrapper,
    User? user,
  })  : _loadUserByUsernameUseCase = loadUserByUsernameUseCase,
        _countryWithPhoneCodeWrapper =
            countryWithPhoneCodeWrapper ?? CountryWithPhoneCodeWrapper(),
        _validateEmailUseCase = validateEmailUseCase,
        super(
          NewAgentInformationStepState(
            busy: true,
          ),
          user: user,
        ) {
    _streamSubscription = globalSettingCubit.stream.listen((state) {
      if (state.busy) return;
      final minimumCharactersSetting = state.settings.firstWhereOrNull(
        (setting) => setting.code == 'minimum_characters',
      ) as GlobalSetting<int>?;
      final usernameMinChars = minimumCharactersSetting?.value;
      final maximumCharactersSetting = state.settings.firstWhereOrNull(
        (setting) => setting.code == 'maximum_characters',
      ) as GlobalSetting<int>?;
      final usernameMaxChars = maximumCharactersSetting?.value;
      final maxFileSizeSetting = state.settings.firstWhereOrNull(
        (setting) => setting.code == 'image_size',
      ) as GlobalSetting<int>?;
      final maxFileSize = maxFileSizeSetting?.value;
      final usernameAllowedCharactersSetting = state.settings.firstWhereOrNull(
        (setting) =>
            setting.module == 'customer_username' &&
            setting.code == 'allowed_characters',
      ) as GlobalSetting<String>?;
      final usernameAllowedCharacters = usernameAllowedCharactersSetting?.value;
      emit(
        this.state.copyWith(
              usernameMinChars: usernameMinChars,
              usernameMaxChars: usernameMaxChars,
              maxFileSize: maxFileSize,
              usernameAllowedCharacters: usernameAllowedCharacters,
              busy: false,
              error: AgentInformationStepStateError.none,
            ),
      );
    });
    globalSettingCubit.load(module: 'customer_username');
    if (user != null) {
      final mobileNumber = user.mobileNumber?.replaceFirst('+', '');
      final phoneCode = _countryWithPhoneCodeWrapper
          .getCountryDataByPhone(mobileNumber ?? '')
          ?.phoneCode;
      final numberWithoutCode = mobileNumber?.replaceFirst(phoneCode ?? '', '');
      emit(
        state.copyWith(
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          dialCode: phoneCode == null ? null : phoneCode,
          mobileNumber: numberWithoutCode,
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
      );
    }
  }

  @override
  User get user => User(
        id: '',
        username: state.username,
        firstName: state.firstName,
        lastName: state.lastName,
        mobileNumber: state.dialCode + state.mobileNumber,
        email: state.email,
        gender: state.gender,
        maritalStatus: state.maritalStatus,
        dob: state.dob,
        agentCustomerId: state.customerId,
        branch: state.branchId,
        motherName: state.motherName,
        address: state.address,
        image: state.image,
      );

  UsernameErrorType _getUsernameError(String text) {
    var errorType = UsernameErrorType.none;
    if (text.isEmpty) {
      errorType = UsernameErrorType.empty;
    } else if (text.length < state.usernameMinChars) {
      errorType = UsernameErrorType.minChars;
    } else if (text.length > state.usernameMaxChars) {
      errorType = UsernameErrorType.maxChars;
    }
    return errorType;
  }

  /// Handles event of username changes,
  /// which is required parameter.
  ///
  /// Influences to [onContinue] method:
  /// if username error type is not [UsernameErrorType.none],
  /// process can't be moved to next step.
  void onUsernameChange(String text) => emit(
        state.copyWith(
          username: text,
          usernameError: _getUsernameError(text),
          action: StepsStateAction.editAction,
          completed: false,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles event of first name changes,
  /// which is required parameter.
  ///
  /// Influences to [onContinue] method:
  /// if first name is empty, process can't be moved to next step.
  void onFirstNameChange(String text) =>
      state.firstNameErrorDisplayed && text.isNotEmpty
          ? emit(state.copyWith(
              firstName: text,
              firstNameErrorDisplayed: false,
              action: StepsStateAction.editAction,
              completed: false,
              error: AgentInformationStepStateError.none,
            ))
          : emit(state.copyWith(
              firstName: text,
              action: StepsStateAction.editAction,
              completed: false,
              error: AgentInformationStepStateError.none,
            ));

  /// Handles event of last name changes,
  /// which is required parameter.
  ///
  /// Influences to [onContinue] method:
  /// if last name is empty, process can't be moved to next step.
  void onLastNameChange(String text) =>
      state.lastNameErrorDisplayed && text.isNotEmpty
          ? emit(state.copyWith(
              lastName: text,
              lastNameErrorDisplayed: false,
              action: StepsStateAction.editAction,
              completed: false,
              error: AgentInformationStepStateError.none,
            ))
          : emit(state.copyWith(
              lastName: text,
              action: StepsStateAction.editAction,
              completed: false,
              error: AgentInformationStepStateError.none,
            ));

  /// Handles event of dial code changes,
  /// which is required parameter.
  void onDialCodeChange(String text) => emit(state.copyWith(
        dialCode: text,
        action: StepsStateAction.editAction,
        error: AgentInformationStepStateError.none,
      ));

  /// Handles event of mobile number changes,
  /// which is required parameter.
  ///
  /// Influences to [onContinue] method:
  /// if mobile number is empty, process can't be moved to next step.
  void onMobileNumberChange(String text) =>
      state.mobileNumberErrorDisplayed && text.isNotEmpty
          ? emit(state.copyWith(
              mobileNumber: text,
              mobileNumberErrorDisplayed: false,
              action: StepsStateAction.editAction,
              completed: false,
              error: AgentInformationStepStateError.none,
            ))
          : emit(state.copyWith(
              mobileNumber: text,
              action: StepsStateAction.editAction,
              completed: false,
              error: AgentInformationStepStateError.none,
            ));

  EmailErrorType _getEmailError(String text) {
    if (text.isEmpty) return EmailErrorType.empty;

    var emailError = EmailErrorType.none;

    if (!_validateEmailUseCase(email: text)) {
      emailError = EmailErrorType.invalid;
    }

    return emailError;
  }

  /// Handles event of email changes,
  /// which is required parameter.
  ///
  /// Influences to [onContinue] method:
  /// if email is empty, process can't be moved to next step.
  void onEmailChange(String text) => emit(
        state.copyWith(
          email: text,
          emailError: _getEmailError(text),
          action: StepsStateAction.editAction,
          completed: false,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles event of mother's name changes
  void onMotherNameChange(String text) => emit(state.copyWith(
        motherName: text,
        action: StepsStateAction.editAction,
        error: AgentInformationStepStateError.none,
      ));

  /// Handles the event of branch changes.
  void onBranchChanged(String branchId) => emit(
        state.copyWith(
          branchId: branchId,
          action: StepsStateAction.editAction,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles the marital status change.
  void onMaritalStatusChanged(CustomerMaritalStatus maritalStatus) => emit(
        state.copyWith(
          maritalStatus: maritalStatus,
          action: StepsStateAction.editAction,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles the gender change.
  void onGenderChanged(CustomerGender gender) => emit(
        state.copyWith(
          gender: gender,
          action: StepsStateAction.editAction,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles the customer ID change.
  void onCustomerIdChanged(String customerId) => emit(
        state.copyWith(
          customerId: customerId,
          action: StepsStateAction.editAction,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles the address change.
  void onAddressChanged(String address) => emit(
        state.copyWith(
          address: address,
          action: StepsStateAction.editAction,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles the date of birth change.
  void onDOBChanged(DateTime dob) => emit(
        state.copyWith(
          dob: dob,
          action: StepsStateAction.editAction,
          error: AgentInformationStepStateError.none,
        ),
      );

  /// Handles the profile image.
  void onImageFileChanged(String image) => emit(
        state.copyWith(
          image: image,
          action: StepsStateAction.editAction,
        ),
      );

  @override
  Future<bool> onContinue() async {
    if (state.usernameError == UsernameErrorType.none &&
        state.firstName.isNotEmpty &&
        state.lastName.isNotEmpty &&
        state.mobileNumber.isNotEmpty &&
        state.email.isNotEmpty) {
      if (isEdit) {
        return true;
      }
      emit(
        state.copyWith(
          action: StepsStateAction.continueAction,
          error: AgentInformationStepStateError.none,
        ),
      );
      try {
        await _loadUserByUsernameUseCase(state.username);
        // If the use case above doesn't throw it means that a user with this
        // username already exists.
        emit(
          state.copyWith(
            completed: false,
            error: AgentInformationStepStateError.usernameExists,
          ),
        );
        return false;
      } on UserNotFoundException {
        // If the user was not found it means that we can proceed with that
        // username.
        emit(
          state.copyWith(
            completed: true,
            error: AgentInformationStepStateError.none,
          ),
        );
        return true;
      } on Exception catch (_) {
        emit(
          state.copyWith(
            error: AgentInformationStepStateError.generic,
          ),
        );
        return false;
      }
    }
    emit(
      state.copyWith(
        usernameError: _getUsernameError(state.username),
        firstNameErrorDisplayed: state.firstName.isEmpty,
        lastNameErrorDisplayed: state.lastName.isEmpty,
        mobileNumberErrorDisplayed: state.mobileNumber.isEmpty,
        emailError: _getEmailError(state.email),
        action: StepsStateAction.continueAction,
        completed: false,
        error: AgentInformationStepStateError.none,
      ),
    );
    return false;
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
