/// An interface representing a data validation strategy
/// to be used in the registration process.
///
/// [T] type parameter represents the type of data validated by this strategy.
abstract class RegistrationFormValidationStrategy<T> {
  /// Returns true if the strategy can validate the data
  /// for the input of provided [RegistrationInputType].
  bool isApplicable(RegistrationInputType type);

  /// Returns key of the container message of the error to be displayed
  /// to the user, or null if the value is valid.
  RegistrationFormValidationError validate(T? value);
}

/// The possible registration form field validation errors.
enum RegistrationFormValidationError {
  /// The form field is valid.
  none,

  /// The field is required and value was not provided.
  fieldRequired,

  /// The provided value was is not valid.
  fieldInvalid,
}

/// All types of inputs used in the registration flows.
enum RegistrationInputType {
  // Keep this section alphabetized

  /// The card verification code.
  cardCvv,

  /// The card expiry date.
  cardExpiry,

  /// The card number.
  cardNumber,

  /// The customers mobile number.
  mobileNumber,
}
