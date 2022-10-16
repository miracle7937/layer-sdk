import 'package:dio/dio.dart';

import '../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';

/// Provides data about the Receipt
class ReceiptProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [ReceiptProvider] with the supplied netClient.
  ReceiptProvider(
    this.netClient,
  );

  /// Resends the receipt with [type] for the passed [object].
  Future<List<int>> getReceipt({
    required String objectId,
    required ReceiptActionType actionType,
    FileType type = FileType.image,
  }) async {
    final response = await netClient.request(
      '${actionType.toQueryString(netClient.netEndpoints)}/$objectId',
      method: NetRequestMethods.post,
      data: {
        'form_id': actionType.toQueryData(),
        'format': type.toFormat(),
      },
      decodeResponse: false,
      responseType: ResponseType.bytes,
    );
    if (response.data is List<int>) {
      return response.data as List<int>;
    }

    throw Exception('Receipt is not received');
  }
}
