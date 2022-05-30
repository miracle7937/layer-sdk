import 'package:dio/dio.dart';

import '../../../migration/data_layer/network.dart';

/// A general provider for uploading/downloading files on the endpoints.
class FileProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [FileProvider] with the given netClient.
  FileProvider({
    required this.netClient,
  });

  /// Generic method to download a file from the supplied [url].
  Future<dynamic> downloadFile({
    required String url,
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    bool forceRefresh = false,
    NetProgressCallback? onReceiveProgress,
  }) async {
    final response = await netClient.request(
      url,
      queryParameters: queryParameters,
      forceRefresh: forceRefresh,
      responseType: ResponseType.bytes,
      onReceiveProgress: onReceiveProgress,
      decodeResponse: false,
    );

    return response.data;
  }
}
