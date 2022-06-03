import '../../../../resources.dart';
import '../../../../strategies.dart';

/// A simple validation strategy that checks if the value is not null
/// and if it's not empty for values of type String.
///
/// NOTE: This strategy is always applicable - if you want to use it together
/// with another strategy make sure to make put this one as the end
/// of the strategies list, so that more selective strategies
/// can take precedence.
class NotEmptyRegistrationValidationStrategy
    implements RegistrationFormValidationStrategy<dynamic> {
  @override
  bool isApplicable(RegistrationInputType type) {
    return true;
  }

  @override
  RegistrationFormValidationError validate(dynamic value) {
    var valid = value != null;
    if (value is String && valid) {
      valid = value.isNotEmpty;
    }
    return valid
        ? RegistrationFormValidationError.none
        : RegistrationFormValidationError.fieldRequired;
  }
}
