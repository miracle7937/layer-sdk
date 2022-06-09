import '../../../features/dpa.dart';

/// Use case that resumes an ongoing DPA process using the given id.
class ResumeDPAProcessUsecase {
  final DPARepositoryInterface _repository;

  /// Creates a new [ResumeDPAProcessUsecase] instance.
  const ResumeDPAProcessUsecase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Resumes an ongoing DPA process using the given id.
  ///
  /// Returns a [DPAProcess] with the current step of the process.
  Future<DPAProcess> call({
    required String id,
  }) =>
      _repository.resumeProcess(
        id: id,
      );
}
