import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to load all Mandates data
class LoadMandatesUseCase {
  final MandateRepositoryInterface _repo;

  /// Creates a new [LoadMandatesUseCase] instance
  LoadMandatesUseCase({
    required MandateRepositoryInterface repository,
  }) : _repo = repository;

  /// Callable method to load all [Mandate]s
  Future<List<Mandate>> call({
    int? mandateId,
    int? limit,
    int? offset,
  }) {
    return _repo.listMandates(
      mandateId: mandateId,
      limit: limit,
      offset: offset,
    );
  }
}
