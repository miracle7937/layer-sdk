import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../providers.dart';

/// Customer certificates repository
class CertificateRepository implements CertificateRepositoryInterface {
  /// The NetClient to use for the network requests
  final CertificateProvider _provider;

  /// Creates a new [CertificateRepository] instance
  CertificateRepository(
    CertificateProvider provider,
  ) : _provider = provider;

  /// Request a new `Certificate of deposit`
  /// Returns the file list of bytes to be used by the application
  @override
  Future<List<int>> requestCertificateOfDeposit({
    required String customerId,
    required String accountId,
    FileType type = FileType.image,
  }) {
    return _provider.requestCertificateOfDeposit(
      accountId: accountId,
      customerId: customerId,
      type: type,
    );
  }

  /// Request a new `Account certificate`
  /// Returns the file list of bytes to be used by the application
  @override
  Future<List<int>> requestAccountCertificate({
    required String customerId,
    required String accountId,
    FileType type = FileType.image,
  }) {
    return _provider.requestAccountCertificate(
      accountId: accountId,
      customerId: customerId,
      type: type,
    );
  }

  /// Request a new `Bank statement`
  /// Returns the file list of bytes to be used by the application
  @override
  Future<List<int>> requestBankStatement({
    required String customerId,
    required String accountId,
    required DateTime fromDate,
    required DateTime toDate,
    FileType type = FileType.image,
  }) {
    return _provider.requestBankStatement(
      accountId: accountId,
      customerId: customerId,
      fromDate: fromDate,
      toDate: toDate,
      type: type,
    );
  }
}
