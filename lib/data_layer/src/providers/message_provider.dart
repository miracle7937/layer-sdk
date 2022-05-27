import '../../network.dart';
import '../dtos.dart';

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

    return response.data is List
        ? MessageDTO.fromJsonList(response.data as List)
        : [];
  }
}
