import '../../../../resources.dart';
import '../../../../strategies.dart';

/// A validation strategy that checks if the expiry date is a valid date that
/// has not passed yet.
///
/// The value should follow the `MM/yy` format, whitespace does not affect
/// the validation result.
class CardExpiryDateValidationStrategy
    extends RegistrationFormValidationStrategy<String> {
  @override
  bool isApplicable(RegistrationInputType type) =>
      type == RegistrationInputType.cardExpiry;

  @override
  RegistrationFormValidationError validate(String? value) {
    final now = DateTime.now();
    if (value == null) return RegistrationFormValidationError.fieldRequired;

    final truncatedExpiryDate = value.replaceAll(' ', '');

    if (truncatedExpiryDate.length != 5) {
      // The input value is incomplete
      return truncatedExpiryDate.isEmpty
          ? RegistrationFormValidationError.fieldRequired
          : RegistrationFormValidationError.fieldInvalid;
    }
    final expiryMonth = int.parse(truncatedExpiryDate.substring(0, 2));
    final expiryYear = int.parse(truncatedExpiryDate.substring(3));
    final currentYear = int.parse(now.year.toString().substring(2));

    if (expiryYear < currentYear ||
        (expiryYear == currentYear && expiryMonth < now.month)) {
      // The expiry date is in the past
      return RegistrationFormValidationError.fieldInvalid;
    }

    if (expiryYear > currentYear) {
      if (expiryMonth < 1 || expiryMonth > 12) {
        // The month is invalid
        return RegistrationFormValidationError.fieldInvalid;
      }
    }

    return RegistrationFormValidationError.none;
  }
}
