import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use get to fetch all messages
class LoadMessageUseCase {
  final MessageRepositoryInterface _repository;

  /// Creates a new instance of [LoadMessageUseCase]
  LoadMessageUseCase({
    required MessageRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to fetch all messages
  Future<List<Message>> call({bool forceRefresh = false}) {
    return _repository.getMessages(forceRefresh: forceRefresh);
  }
}
