import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit that loads all permission objects with its descriptions.
class PermissionDetailsCubit extends Cubit<PermissionDetailsState> {
  final LoadPermissionsUseCase _loadPermissionsUseCase;

  /// Creates a new [PermissionDetailsCubit] instance.
  PermissionDetailsCubit({
    required LoadPermissionsUseCase loadPermissionsUseCase,
  })  : _loadPermissionsUseCase = loadPermissionsUseCase,
        super(
          PermissionDetailsState(),
        );

  /// Lists all permissions.
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        error: false,
      ),
    );

    try {
      final list = await _loadPermissionsUseCase();

      emit(
        state.copyWith(
          busy: false,
          permissions: list,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: true,
          permissions: [],
        ),
      );
    }
  }
}
