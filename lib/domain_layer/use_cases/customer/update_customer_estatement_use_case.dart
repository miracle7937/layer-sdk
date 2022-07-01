import '../../abstract_repositories.dart';

/// Use case to update customer e-statment
class UpdateCustomerEStatementUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [UpdateCustomerEStatementUseCase]
  UpdateCustomerEStatementUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Updates the customer e-statment value based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  Future<bool> call({
    required String customerId,
    required bool value,
  }) =>
      _repository.updateCustomerEStatement(
        customerId: customerId,
        value: value,
      );
}
