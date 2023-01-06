import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for [User] [Roles].
class RolesCubit extends Cubit<RolesState> {
  final LoadCustomerRolesUseCase _loadCustomerRolesUseCase;

  /// Creates a new [RolesCubit] instance.
  RolesCubit({
    required LoadCustomerRolesUseCase loadCustomerRolesUseCase,
  })  : _loadCustomerRolesUseCase = loadCustomerRolesUseCase,
        super(RolesState());

  /// Loads all available customer roles.
  Future<void> listCustomerRoles({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: RolesStateError.none,
      ),
    );

    try {
      final roles = await _loadCustomerRolesUseCase(forceRefresh: forceRefresh);

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
