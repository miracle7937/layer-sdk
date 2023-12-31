import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../network.dart';

/// Customer certificates provider
class CertificateProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [CertificateProvider] instance
  CertificateProvider(
    this.netClient,
  );

  /// Request a new `Certificate of deposit`
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestCertificateOfDeposit({
    required String customerId,
    required String accountId,
    FileType type = FileType.image,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.accountCertificate,
      method: NetRequestMethods.post,
      decodeResponse: false,
      responseType: ResponseType.bytes,
      queryParameters: {
        'customer_id': customerId,
      },
      data: {
        'format': type.toFormat(),
        "form_id": "certificate_deposit",
        "send_by": "response",
        "account_id": accountId,
      },
    );

    if (!response.success) throw Exception();

    return response.data;
  }

  /// Request a new `Account certificate`
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestAccountCertificate({
    required String customerId,
    required String accountId,
    FileType type = FileType.image,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.accountCertificate,
      method: NetRequestMethods.post,
      queryParameters: {
        'customer_id': customerId,
      },
      decodeResponse: false,
      responseType: ResponseType.bytes,
      data: {
        'format': type.toFormat(),
        "form_id": "account_certificate",
        "send_by": "response",
        "account_id": accountId,
      },
    );

    if (!response.success) throw Exception();

    return response.data;
  }

  /// Request a new `Bank statement`
  /// Returns the file list of bytes to be used by the application
  Future<List<int>> requestBankStatement({
    required String accountId,
    required String customerId,
    required DateTime toDate,
    required DateTime fromDate,
    FileType type = FileType.image,
  }) async {
    final format = DateFormat('yyyyMMdd');
    final response = await netClient.request(
      netClient.netEndpoints.officialBankStatement,
      method: NetRequestMethods.post,
      responseType: ResponseType.bytes,
      decodeResponse: false,
      throwAllErrors: false,
      queryParameters: {
        'customer_id': customerId,
      },
      data: {
        'format': type.toFormat(),
        "form_id": "bank_statement",
        "send_by": "response",
        "account_id": accountId,
        "to_date": format.format(toDate),
        "from_date": format.format(fromDate),
      },
    );

    if (!response.success) {
      throw NetException(
        statusCode: response.statusCode,
        code: response.data is Map ? response.data['code'] : null,
        message: response.data is Map ? response.data['message'] : null,
      );
    }

    return response.data;
  }
}
