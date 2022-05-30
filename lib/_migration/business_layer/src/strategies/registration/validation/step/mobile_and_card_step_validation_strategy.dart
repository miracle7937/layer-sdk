import '../../../../../../data_layer/data_layer.dart';

import '../../../../cubits.dart';
import '../../../../strategies.dart';

/// A strategy for validating [MobileAndCardRegistrationParameters]
/// that checks if all the fields are valid.
// TODO: fix the registration validation, this class is all kinds of wrong.
class MobileAndCardStepValidationStrategy
    extends RegistrationStepValidationStrategy<
        MobileAndCardRegistrationParameters> {
  final CardNumberFirstSixLastFourValidationStrategy _cardNumberStrategy =
      CardNumberFirstSixLastFourValidationStrategy();
  final CardExpiryDateValidationStrategy _expiryDateStrategy =
      CardExpiryDateValidationStrategy();
  final CVVValidationStrategy _cvvStrategy = CVVValidationStrategy();

  @override
  bool isApplicable(RegistrationStep step) => step
      is AuthenticationRegistrationStep<MobileAndCardRegistrationParameters>;

  @override
  bool validate(MobileAndCardRegistrationParameters parameters) {
    final mobileNumberValid = (parameters.mobileNumber?.isNotEmpty ?? false);
    final cardNumberValid =
        _cardNumberStrategy.validate(parameters.cardNumber) ==
            RegistrationFormValidationError.none;
    final expiryDateValid =
        _expiryDateStrategy.validate(parameters.expiryDate) ==
            RegistrationFormValidationError.none;
    final cvvValid = _cvvStrategy.validate(parameters.cvv) ==
        RegistrationFormValidationError.none;
    return mobileNumberValid && cardNumberValid && expiryDateValid && cvvValid;
  }
}
