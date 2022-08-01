import '../../../features/message.dart';

/// A use case for getting the messages from a module.
class LoadMessagesByModuleUseCase {
  final MessageRepositoryInterface _messageRepository;

  /// Creates a new [LoadMessagesByModuleUseCase] use case.
  const LoadMessagesByModuleUseCase({
    required MessageRepositoryInterface messageRepository,
  }) : _messageRepository = messageRepository;

  /// Return the messages from the passed module.
  Future<List<Message>> call({
    required String module,
  }) =>
      _messageRepository.getMessages(
        module: module,
      );
}
