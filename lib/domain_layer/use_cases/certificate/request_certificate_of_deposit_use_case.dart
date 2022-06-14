import '../../abstract_repositories.dart';

/// Use case to request a certificate of deposit
class RequestCertificateOfDepositUseCase {
  final CertificateRepositoryInterface _repository;

  /// Creates a new [RequestCertificateOfDepositUseCase] instance
  RequestCertificateOfDepositUseCase({
    required CertificateRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to request a certificate of deposit
  ///
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> call({
    required String customerId,
    required String accountId,
  }) {
    return _repository.requestCertificateOfDeposit(
      customerId: customerId,
      accountId: accountId,
    );
  }
}
