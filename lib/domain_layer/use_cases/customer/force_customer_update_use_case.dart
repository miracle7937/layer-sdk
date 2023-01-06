import '../../../features/customer.dart';

/// Use case that requests a force update for the provided `customerId`.
class ForceCustomerUpdateUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [ForceCustomerUpdateUseCase] instance.
  ForceCustomerUpdateUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Forces a update of the user associated to the provided `customerId`.
  ///
  /// Returns whether or not the request was successfull.
  Future<bool> call({
    required String customerId,
  }) =>
      _repository.forceCustomerUpdate(
        customerId: customerId,
      );
}
