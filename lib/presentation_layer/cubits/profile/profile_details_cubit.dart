import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that manages the state of the [Profile]s.
class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  final GetProfileUseCase _getProfileUseCase;

  /// Creates the [ProfileDetailsCubit].
  ProfileDetailsCubit({
    required GetProfileUseCase getProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        super(
          ProfileDetailsState(),
        );

  /// Loads the [Profile] by [customerId]
  Future<void> getProfile({
    required String customerId,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: ProfileDetailsStateError.none,
      ),
    );

    try {
      final profile = await _getProfileUseCase(
        customerID: customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          busy: false,
          profile: profile,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: ProfileDetailsStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Clear the [Profile] in state
  Future<void> clearProfile() async {
    emit(ProfileDetailsState());
  }
}
