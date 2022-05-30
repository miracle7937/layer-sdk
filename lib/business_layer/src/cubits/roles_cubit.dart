import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../../../migration/data_layer/network.dart';
import '../cubits.dart';

/// Cubit responsible for [User] [Roles].
class RolesCubit extends Cubit<RolesState> {
  final RolesRepository _repository;

  /// Creates a new [RolesCubit] instance.
  RolesCubit({
    required RolesRepository repository,
  })  : _repository = repository,
        super(RolesState());

  /// Loads all available customer roles.
  void listCustomerRoles({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: RolesStateError.none,
      ),
    );

    try {
      final roles = await _repository.listCustomerRoles(
        forceRefresh: forceRefresh,
      );
      emit(
        state.copyWith(
          busy: false,
          roles: roles,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? RolesStateError.network
              : RolesStateError.generic,
        ),
      );

      rethrow;
    }
  }
}
