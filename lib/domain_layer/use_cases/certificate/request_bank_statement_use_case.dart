import '../../abstract_repositories.dart';

/// Use case to request bank statement
class RequestBankStatementUseCase {
  final CertificateRepositoryInterface _repository;

  /// Creates a new [RequestBankStatementUseCase] instance
  RequestBankStatementUseCase({
    required CertificateRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to request bank statement
  ///
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> call({
    required String customerId,
    required String accountId,
    required DateTime fromDate,
    required DateTime toDate,
  }) =>
      _repository.requestBankStatement(
        customerId: customerId,
        accountId: accountId,
        fromDate: fromDate,
        toDate: toDate,
      );
}
