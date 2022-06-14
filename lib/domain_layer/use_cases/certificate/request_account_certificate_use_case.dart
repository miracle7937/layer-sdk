import '../../abstract_repositories.dart';

/// Use case to request the account certificate
class RequestAccountCertificateUseCase {
  final CertificateRepositoryInterface _repository;

  /// Creates a new [RequestAccountCertificateUseCase] instance
  RequestAccountCertificateUseCase({
    required CertificateRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to request the account certificate
  ///
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> call({
    required String customerId,
    required String accountId,
  }) {
    return _repository.requestAccountCertificate(
      customerId: customerId,
      accountId: accountId,
    );
  }
}
