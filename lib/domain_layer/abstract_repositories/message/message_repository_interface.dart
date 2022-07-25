import '../../models.dart';

/// An abstract repository for the messages.
abstract class MessageRepositoryInterface {
  /// Returns all available messages.
  Future<List<Message>> getMessages({
    bool forceRefresh = false,
  });

  /// Returns a list of messages related to the passed module.
  Future<List<Message>> get({
    String? module,
    bool forceRefresh = false,
  });
}
