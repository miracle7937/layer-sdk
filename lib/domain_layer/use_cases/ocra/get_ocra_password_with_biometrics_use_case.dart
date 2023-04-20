/// The base class for retrieving the password used in the OCRA flow from the
/// biometrics secure storage.
///
/// Implementations of this interface should retrieve the specific value from
/// storage that triggers biometrics check on every value read.
abstract class GetOcraPasswordWithBiometricsUseCase {
  /// Returns the password to be used in the OCRA flow.
  Future<String> call({
    String promptTitle = '',
  });
}
