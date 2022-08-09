import '../../../domain_layer/abstract_repositories/payments/services_repository_interface.dart';
import '../../../domain_layer/models/service/service.dart';
import '../../mappings/service/service_dto_mapping.dart';
import '../../providers/payments/service_provider.dart';

/// Handles all the service data
class ServicesRepository extends ServicesRepositoryInterface {
  final ServiceProvider _provider;

  /// Creates a new repository with the supplied [ServiceProvider]
  ServicesRepository(
    ServiceProvider provider,
  ) : _provider = provider;

  @override
  Future<List<Service>> listServices({
    String? billerId,
    bool sortByName = false,
  }) async {
    final services = await _provider.list(
      billerId: billerId,
      sortByName: sortByName,
    );

    return services.map((e) => e.toService()).toList(growable: false);
  }
}
