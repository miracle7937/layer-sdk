import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// A repository that can be used to fetch [Message].
class MessageRepository {
  final MessageProvider _messageProvider;

  /// Creates a new repository with the supplied [MessageProvider].
  MessageRepository({
    required MessageProvider messageProvider,
  }) : _messageProvider = messageProvider;

  /// Fetches the list of [Message]
  Future<List<Message>> getMessages({
    bool forceRefresh = false,
  }) async {
    final messagesDTO = await _messageProvider.getMessages(
      forceRefresh: forceRefresh,
    );

    return messagesDTO.map<Message>((dto) => dto.toMessage()).toList();
  }
}
