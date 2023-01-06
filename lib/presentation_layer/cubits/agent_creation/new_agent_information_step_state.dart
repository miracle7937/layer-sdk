import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The state of the [NewAgentInformationStepCubit]
class NewAgentInformationStepState extends NewAgentStepState {
  /// Username.
  final String username;

  /// Type of username error.
  final UsernameErrorType usernameError;

  /// Minimum characters number for username.
  final int usernameMinChars;

  /// Maximum characters number for username.
  final int usernameMaxChars;

  /// First name.
  final String firstName;

  /// Whether or not this first name error displayed.
  final bool firstNameErrorDisplayed;

  /// Last name.
  final String lastName;

  /// Whether or not this last name error displayed.
  final bool lastNameErrorDisplayed;

  /// Dial code.
  final String dialCode;

  /// Mobile number.
  final String mobileNumber;

  /// Whether or not this mobile number error displayed.
  final bool mobileNumberErrorDisplayed;

  /// Email.
  final String email;

  /// Type of email error.
  final EmailErrorType emailError;

  /// Mother's name.
  final String motherName;

  /// The ID of the selected branch.
  final String branchId;

  /// The marital status.
  final CustomerMaritalStatus? maritalStatus;

  /// The selected gender.
  final CustomerGender? gender;

  /// Customer ID.
  final String customerId;

  /// Address.
  final String address;

  /// Date of birth.
  final DateTime? dob;

  /// The last occurred error
  final AgentInformationStepStateError error;

  /// Base64 image.
  final String image;

  /// The maximum size for the image file
  ///
  /// Default to zero, means no limit
  final int maxFileSize;

  /// The allowed characters for the username field.
  final String usernameAllowedCharacters;

  /// Creates [NewAgentInformationStepState].
  const NewAgentInformationStepState({
    this.username = '',
    this.usernameError = UsernameErrorType.none,
    this.usernameMinChars = 6,
    this.usernameMaxChars = 15,
    this.firstName = '',
    this.firstNameErrorDisplayed = false,
    this.lastName = '',
    this.lastNameErrorDisplayed = false,
    this.dialCode = '',
    this.mobileNumber = '',
    this.mobileNumberErrorDisplayed = false,
    this.email = '',
    this.emailError = EmailErrorType.none,
    this.motherName = '',
    this.branchId = '',
    this.maritalStatus,
    this.gender,
    this.customerId = '',
    this.address = '',
    this.dob,
    this.error = AgentInformationStepStateError.none,
    this.image = '',
    this.maxFileSize = 0,
    StepsStateAction action = StepsStateAction.none,
    bool filled = false,
    bool busy = false,
    this.usernameAllowedCharacters = '',
  }) : super(
          action: action,
          completed: filled,
          busy: busy,
        );

  /// Creates a new state based on this one.
  @override
  NewAgentInformationStepState copyWith({
    String? username,
    UsernameErrorType? usernameError,
    int? usernameMinChars,
    int? usernameMaxChars,
    String? firstName,
    bool? firstNameErrorDisplayed,
    String? lastName,
    bool? lastNameErrorDisplayed,
    String? email,
    String? dialCode,
    String? mobileNumber,
    bool? mobileNumberErrorDisplayed,
    EmailErrorType? emailError,
    String? motherName,
    StepsStateAction? action,
    bool? completed,
    bool? busy,
    String? branchId,
    CustomerMaritalStatus? maritalStatus,
    CustomerGender? gender,
    String? customerId,
    String? address,
    DateTime? dob,
    AgentInformationStepStateError? error,
    String? image,
    int? maxFileSize,
    String? usernameAllowedCharacters,
  }) =>
      NewAgentInformationStepState(
        username: username ?? this.username,
        usernameError: usernameError ?? this.usernameError,
        usernameMinChars: usernameMinChars ?? this.usernameMinChars,
        usernameMaxChars: usernameMaxChars ?? this.usernameMaxChars,
        firstName: firstName ?? this.firstName,
        firstNameErrorDisplayed:
            firstNameErrorDisplayed ?? this.firstNameErrorDisplayed,
        lastName: lastName ?? this.lastName,
        lastNameErrorDisplayed:
            lastNameErrorDisplayed ?? this.lastNameErrorDisplayed,
        dialCode: dialCode ?? this.dialCode,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        mobileNumberErrorDisplayed:
            mobileNumberErrorDisplayed ?? this.mobileNumberErrorDisplayed,
        email: email ?? this.email,
        emailError: emailError ?? this.emailError,
        motherName: motherName ?? this.motherName,
        action: action ?? this.action,
        filled: completed ?? this.completed,
        busy: busy ?? this.busy,
        branchId: branchId ?? this.branchId,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        gender: gender ?? this.gender,
        customerId: customerId ?? this.customerId,
        address: address ?? this.address,
        dob: dob ?? this.dob,
        error: error ?? this.error,
        image: image ?? this.image,
        maxFileSize: maxFileSize ?? this.maxFileSize,
        usernameAllowedCharacters:
            usernameAllowedCharacters ?? this.usernameAllowedCharacters,
      );

  @override
  List<Object?> get props => [
        action,
        completed,
        busy,
        username,
        usernameError,
        usernameMinChars,
        usernameMaxChars,
        firstName,
        firstNameErrorDisplayed,
        lastName,
        lastNameErrorDisplayed,
        dialCode,
        mobileNumber,
        mobileNumberErrorDisplayed,
        email,
        emailError,
        motherName,
        branchId,
        maritalStatus,
        gender,
        customerId,
        address,
        dob,
        error,
        image,
        maxFileSize,
        usernameAllowedCharacters,
      ];
}

/// Types of username validation errors.
enum UsernameErrorType {
  /// No error.
  none,

  /// Username is empty.
  empty,

  /// Length of username is shorter than allowed by settings.
  minChars,

  /// Length of username is longer than allowed by settings.
  maxChars,
}

/// Types of email validation errors.
enum EmailErrorType {
  /// No error.
  none,

  /// Email is empty.
  empty,

  /// Email is invalid.
  invalid,
}

/// All possible errors for [AgentCreationState]
enum AgentInformationStepStateError {
  /// No error
  none,

  /// Generic error
  generic,

  /// Generic error
  usernameExists,
}
