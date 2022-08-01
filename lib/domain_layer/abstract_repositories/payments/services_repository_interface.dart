import '../../models/service/service.dart';

/// Abstract definition of the repository that handles all the
/// biller service data.
abstract class ServicesRepositoryInterface {
  /// Lists all the services
  ///
  /// * Use `billerId` to get services for a specific biller
  /// * Use `sortByName` to sort the services by their name
  Future<List<Service>> listServices({
    String? billerId,
    bool sortByName = false,
  });
}
