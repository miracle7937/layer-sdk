import '../../abstract_repositories.dart';

/// Callable method to patches the list of blocked channels
class PatchUserBlockedChannelUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [PatchUserBlockedChannelUseCase] instance
  PatchUserBlockedChannelUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to patches the list of blocked channels
  /// for the provided user id.
  ///
  /// Used only by the DBO app.
  Future<bool> call({
    required String userId,
    required List<String> channels,
  }) =>
      _repository.patchUserBlockedChannels(
        userId: userId,
        channels: channels,
      );
}
