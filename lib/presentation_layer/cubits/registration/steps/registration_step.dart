import '../../../cubits.dart';

/// An interface representing a single step of the registration process.
///
/// A callable class.
///
/// [T] is the type of parameters used by this step.
// ignore: one_member_abstracts
abstract class RegistrationStep<T> {
  /// Performs all the logic related to that step and returns a modified state.
  ///
  /// Should catch any exceptions thrown and provide an error message
  /// to be displayed to the user in the `stepError` parameter of the state.
  ///
  /// Should increment the `currentStep` parameter of the state
  /// if the operation succeeded.
  Future<RegistrationState> call({
    required T parameters,
    required RegistrationState state,
  });
}
