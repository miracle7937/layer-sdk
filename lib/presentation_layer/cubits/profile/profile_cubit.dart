import 'package:bloc/bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../data_layer/repositories.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that for the customers profile
class ProfileCubit extends Cubit<ProfileState> {
  final LoadCurrentCustomerUseCase _customerUseCase;
  final LoadUserByCustomerIdUseCase _loadUserUseCase;
  final LoadCustomerImageUseCase _loadCustomerImageUseCase;
  final PatchUserImageUseCase _patchUserImageUseCase;

  /// Creates a new cubit using the supplied [CustomerRepository].
  ProfileCubit({
    required LoadCurrentCustomerUseCase customerUseCase,
    required LoadUserByCustomerIdUseCase loadUserUseCase,
    required LoadCustomerImageUseCase loadCustomerImageUseCase,
    required PatchUserImageUseCase patchUserImageUseCase,
  })  : _customerUseCase = customerUseCase,
        _loadUserUseCase = loadUserUseCase,
        _loadCustomerImageUseCase = loadCustomerImageUseCase,
        _patchUserImageUseCase = patchUserImageUseCase,
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

  /// Loads the customers image
  Future<void> loadImage({required String imageURL}) async {
    emit(
      state.copyWith(
        actions: state.actions.union({ProfileBusyAction.loadingImage}),
        error: ProfileErrorStatus.none,
      ),
    );

    try {
      final image = await _loadCustomerImageUseCase(
        imageURL: imageURL,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({ProfileBusyAction.loadingImage}),
          image: image,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({ProfileBusyAction.loadingImage}),
          error: ProfileErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }

  /// Saves the newly selected photo
  Future<void> savePhoto() async {
    if (state.base64 != null) {
      try {
        emit(
          state.copyWith(
            actions: state.actions.union({ProfileBusyAction.uploadingImage}),
            error: ProfileErrorStatus.none,
          ),
        );
        await _patchUserImageUseCase.patchImage(
          base64: state.base64!,
        );

        emit(
          state.copyWith(
            actions:
                state.actions.difference({ProfileBusyAction.uploadingImage}),
          ),
        );
      } on Exception {
        emit(
          state.copyWith(
            actions:
                state.actions.difference({ProfileBusyAction.uploadingImage}),
            error: ProfileErrorStatus.generic,
          ),
        );

        rethrow;
      }
    }
  }

  /// Sets the base64
  void setBase64({required String? base64}) {
    emit(
      state.copyWith(
        base64: base64,
      ),
    );
  }
}
