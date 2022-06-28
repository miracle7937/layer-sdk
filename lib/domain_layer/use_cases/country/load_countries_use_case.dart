import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to load all available countries
class LoadCountriesUseCase {
  final CountryRepositoryInterface _repository;

  /// Creates a new [LoadCountriesUseCase] instance
  LoadCountriesUseCase({
    required CountryRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all available countries
  Future<List<Country>> call({
    bool registration = false,
    bool forceRefresh = false,
  }) {
    return _repository.list(
      registration: registration,
      forceRefresh: forceRefresh,
    );
  }
}
