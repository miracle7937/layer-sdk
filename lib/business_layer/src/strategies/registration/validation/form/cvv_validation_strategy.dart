import '../../../../resources.dart';
import '../../../../strategies.dart';

/// A validation strategy that checks if the cvv code contains only digits and
/// is of valid length.
///
/// By default codes with length 3 or 4 are valid.
class CVVValidationStrategy extends RegistrationFormValidationStrategy<String> {
  /// The valid values for the cvv code length.
  final List<int> validLengths;

  /// Creates [CVVValidationStrategy].
  CVVValidationStrategy({
    this.validLengths = const [3, 4],
  });

  @override
  bool isApplicable(RegistrationInputType type) =>
      type == RegistrationInputType.cardCvv;

  @override
  RegistrationFormValidationError validate(String? value) {
    if (value == null || value.isEmpty) {
      return RegistrationFormValidationError.fieldRequired;
    }
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length != digits.length || !validLengths.contains(value.length)) {
      return RegistrationFormValidationError.fieldInvalid;
    }
    return RegistrationFormValidationError.none;
  }
}
