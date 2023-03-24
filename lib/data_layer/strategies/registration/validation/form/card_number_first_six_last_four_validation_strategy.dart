import '../../../../strategies.dart';

/// A validation strategy that checks if user provided first six and last four
/// card number digits.
class CardNumberFirstSixLastFourValidationStrategy
    extends RegistrationFormValidationStrategy<String?> {
  @override
  bool isApplicable(RegistrationInputType type) =>
      type == RegistrationInputType.cardNumber;

  @override
  RegistrationFormValidationError validate(String? value) {
    if (value == null || value.isEmpty) {
      return RegistrationFormValidationError.fieldRequired;
    }
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length < 10 || digits.length != value.length) {
      return RegistrationFormValidationError.fieldInvalid;
    }
    return RegistrationFormValidationError.none;
  }
}
