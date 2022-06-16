import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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
        "format": "image",
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
        "format": "image",
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
  }) async {
    final format = DateFormat('yyyyMMdd');
    final response = await netClient.request(
      netClient.netEndpoints.officialBankStatement,
      method: NetRequestMethods.post,
      responseType: ResponseType.bytes,
      throwAllErrors: false,
      decodeResponse: false,
      queryParameters: {
        'customer_id': customerId,
      },
      data: {
        "format": "image",
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
      );
    }

    return response.data;
  }
}
