import '../../models.dart';

/// An abstract repository for certificates
abstract class CertificateRepositoryInterface {
  /// Request a new `Certificate of deposit`
  ///
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestCertificateOfDeposit({
    required String customerId,
    required String accountId,
    FileType type = FileType.image,
  });

  /// Request a new `Account certificate`
  ///
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestAccountCertificate({
    required String customerId,
    required String accountId,
    FileType type = FileType.image,
  });

  /// Request a new `Bank statement`
  ///
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestBankStatement({
    required String customerId,
    required String accountId,
    required DateTime fromDate,
    required DateTime toDate,
    FileType type = FileType.image,
  });
}
