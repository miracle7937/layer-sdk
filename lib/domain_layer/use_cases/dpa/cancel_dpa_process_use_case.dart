import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that cancels the given [DPAProcess].
class CancelDPAProcessUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [CancelDPAProcessUseCase] instance.
  const CancelDPAProcessUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Cancels the given [DPAProcess].
  ///
  /// Returns `true` if succeeded.
  Future<bool> call({
    required DPAProcess process,
  }) =>
      _repository.cancelProcess(
        process: process,
      );
}
