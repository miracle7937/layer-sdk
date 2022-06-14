import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to load the [Config]
class LoadConfigUseCase {
  final ConfigRepositoryInterface _repository;

  /// Creates a new [LoadConfigUseCase] instance
  LoadConfigUseCase({
    required ConfigRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load the [Config]
  Future<Config> call({bool forceRefresh = true}) {
    return _repository.load(forceRefresh: forceRefresh);
  }
}
