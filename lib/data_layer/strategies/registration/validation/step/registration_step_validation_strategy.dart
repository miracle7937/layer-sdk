import '../../../../../presentation_layer/cubits.dart';

/// A validation strategy that validates the step parameters.
abstract class RegistrationStepValidationStrategy<T> {
  /// Returns true if strategy is able to validate the parameters
  /// of the given [RegistrationStep].
  bool isApplicable(RegistrationStep step);

  /// Returns true if the given parameters are valid
  /// and the step is ready to be performed.
  bool validate(T parameters);
}
