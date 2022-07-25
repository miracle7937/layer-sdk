import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to [MessageDTO].
class MessageProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [MessageProvider].
  MessageProvider({
    required this.netClient,
  });

  /// Returns the global messages.
  Future<List<MessageDTO>> getMessages({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.message,
      forceRefresh: forceRefresh,
    );

    return response.data is List<Map<String, dynamic>>
        ? MessageDTO.fromJsonList(
            List<Map<String, dynamic>>.from(response.data),
          )
        : [];
  }

  /// Returns the global messages.
  Future<List<MessageDTO>> get({
    bool forceRefresh = false,
    String? module,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.message,
      queryParameters: {
        if (module != null) 'module': module,
      },
      forceRefresh: forceRefresh,
    );

    return response.data is List<Map<String, dynamic>>
        ? MessageDTO.fromJsonList(
            List<Map<String, dynamic>>.from(response.data),
          )
        : [];
  }
}
