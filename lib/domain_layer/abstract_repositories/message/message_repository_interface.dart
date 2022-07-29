import '../../models.dart';

/// An abstract repository for the messages.
abstract class MessageRepositoryInterface {
  /// Returns all available messages.
  Future<List<Message>> getMessages({
    bool forceRefresh = false,
    String? module,
  });
}
