import 'package:bloc/bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../data_layer/repositories.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that for the customers profile
class ProfileCubit extends Cubit<ProfileState> {
  final LoadCurrentCustomerUseCase _customerUseCase;
  final LoadUserByCustomerIdUseCase _loadUserUseCase;

  /// Creates a new cubit using the supplied [CustomerRepository].
  ProfileCubit({
    required LoadCurrentCustomerUseCase customerUseCase,
    required LoadUserByCustomerIdUseCase loadUserUseCase,
  })  : _customerUseCase = customerUseCase,
        _loadUserUseCase = loadUserUseCase,
        super(ProfileState());

  /// Loads the customers data
  /// [forceRefresh] defaults to false, pass it
  /// as true if u want to clear cache
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({ProfileBusyAction.load}),
        error: ProfileErrorStatus.none,
      ),
    );

    try {
      final requests = await Future.wait([
        _customerUseCase(
          forceRefresh: forceRefresh,
        ),
        _loadUserUseCase(
          forceRefresh: forceRefresh,
        )
      ]);

      emit(
        state.copyWith(
          actions: state.actions.difference({ProfileBusyAction.load}),
          customer: requests[0] as Customer,
          user: requests[1] as User,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({ProfileBusyAction.load}),
          error: ProfileErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
