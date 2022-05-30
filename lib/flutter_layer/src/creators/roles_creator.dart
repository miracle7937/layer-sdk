import '../../../business_layer/business_layer.dart';
import '../../../data_layer/data_layer.dart';
import '../widgets.dart';

/// A creator responsible for creating [RolesCubit].
class RolesCreator implements CubitCreator {
  final RolesRepository _repository;

  /// Creates a new [RolesCreator]
  const RolesCreator({
    required RolesRepository repository,
  }) : _repository = repository;

  /// Creates a cubit that contains Loyalty
  RolesCubit create() => RolesCubit(
        repository: _repository,
      );
}
