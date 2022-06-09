import '../../../features/dpa.dart';

/// Use case that starts a new DPA process using the given id, and the optional
/// variables.
class StartDPAProcessUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [StartDPAProcessUseCase] instance.
  const StartDPAProcessUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Starts a new DPA process using the given id, and the optional
  /// variables.
  ///
  /// Returns a [DPAProcess] with the first step of this process.
  Future<DPAProcess> call({
    required String id,
    List<DPAVariable> variables = const [],
  }) =>
      _repository.startProcess(
        id: id,
        variables: variables,
      );
}
