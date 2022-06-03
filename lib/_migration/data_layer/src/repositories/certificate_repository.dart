import '../../providers.dart';

/// Customer certificates repository
class CertificateRepository {
  /// The NetClient to use for the network requests
  final CertificateProvider _provider;

  /// Creates a new [CertificateRepository] instance
  CertificateRepository(
    CertificateProvider provider,
  ) : _provider = provider;

  /// Request a new `Certificate of deposit`
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestCertificateOfDeposit({
    required String customerId,
    required String accountId,
  }) {
    return _provider.requestCertificateOfDeposit(
      accountId: accountId,
      customerId: customerId,
    );
  }

  /// Request a new `Account certificate`
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestAccountCertificate({
    required String customerId,
    required String accountId,
  }) {
    return _provider.requestAccountCertificate(
      accountId: accountId,
      customerId: customerId,
    );
  }

  /// Request a new `Bank statement`
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestBankStatement({
    required String customerId,
    required String accountId,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    return _provider.requestBankStatement(
      accountId: accountId,
      customerId: customerId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
