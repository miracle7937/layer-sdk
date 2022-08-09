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
    String? module,
  }) async {
    final params = module != null ? {'module': module} : null;

    final response = await netClient.request(
      netClient.netEndpoints.message,
      forceRefresh: forceRefresh,
      queryParameters: params,
    );

    return MessageDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
