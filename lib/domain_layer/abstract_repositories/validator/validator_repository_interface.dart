/// An abstract class for the [Validator] repository
abstract class ValidatorRepositoryInterface {
  /// Method to validate transaction pin by `txnPin`
  Future<void> validateTransactionPin({
    required String txnPin,
    required String userId,
  });
}
