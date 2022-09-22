import '../../abstract_repositories/payments/services_repository_interface.dart';
import '../../models/service/service.dart';

/// Use case to load services data
class LoadServicesUseCase {
  final ServicesRepositoryInterface _repository;

  /// Creates a new [LoadServicesUseCase] instance
  LoadServicesUseCase({
    required ServicesRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load services data
  Future<List<Service>> call({
    String? billerId,
    bool sortByName = false,
  }) =>
      _repository.listServices(
        billerId: billerId,
        sortByName: sortByName,
      );
}
