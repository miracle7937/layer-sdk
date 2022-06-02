import '../../abstract_repositories/message/message_repository_interface.dart';
import '../../models.dart';

/// Use get to fetch all messages
class GetMessageUseCase {
  /// Creates a new instance of [GetMessageUseCase]
  GetMessageUseCase(this._repository);

  final MessageRepositoryInterface _repository;

  /// Callable method to fetch all messages
  Future<List<Message>> call({bool forceRefresh = false}) {
    return _repository.getMessages(forceRefresh: forceRefresh);
  }
}
