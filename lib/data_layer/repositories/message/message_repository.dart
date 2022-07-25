import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository that can be used to fetch [Message].
class MessageRepository implements MessageRepositoryInterface {
  final MessageProvider _messageProvider;

  /// Creates a new repository with the supplied [MessageProvider].
  MessageRepository({
    required MessageProvider messageProvider,
  }) : _messageProvider = messageProvider;

  /// Fetches the list of [Message]
  @override
  Future<List<Message>> getMessages({
    bool forceRefresh = false,
  }) async {
    final messagesDTO = await _messageProvider.getMessages(
      forceRefresh: forceRefresh,
    );

    return messagesDTO.map<Message>((dto) => dto.toMessage()).toList();
  }

  /// Fetches the [Message] list related to the passed module.
  @override
  Future<List<Message>> get({
    String? module,
    bool forceRefresh = false,
  }) async {
    final messagesDTO = await _messageProvider.get(
      module: module,
      forceRefresh: forceRefresh,
    );

    return messagesDTO.map<Message>((dto) => dto.toMessage()).toList();
  }
}
