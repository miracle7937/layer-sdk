import '../../models.dart';

abstract class MessageRepositoryInterface {
  Future<List<Message>> getMessages({bool forceRefresh = false});
}
