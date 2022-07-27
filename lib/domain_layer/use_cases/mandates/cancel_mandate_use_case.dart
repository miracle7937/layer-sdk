import '../../abstract_repositories.dart';

/// Use case for canceling Mandates
class CancelMandateUseCase {
  final MandateRepositoryInterface _repo;

  /// Creates a new [CancelMandateUseCase] instance
  CancelMandateUseCase({
    required MandateRepositoryInterface repository,
  }) : _repo = repository;

  /// Callable that cancels a Mandate
  Future<void> call({required int mandateId}) {
    return _repo.cancelMandate(mandateId: mandateId);
  }
}
