import 'dart:convert';

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
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

  /// Creates a new cubit using the supplied [CustomerRepository].
  ProfileCubit({
    required LoadCurrentCustomerUseCase customerUseCase,
    required LoadUserByCustomerIdUseCase loadUserUseCase,
    required LoadCustomerImageUseCase loadCustomerImageUseCase,
    required PatchUserImageUseCase patchUserImageUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
  })  : _customerUseCase = customerUseCase,
        _loadUserUseCase = loadUserUseCase,
        _loadCustomerImageUseCase = loadCustomerImageUseCase,
        _patchUserImageUseCase = patchUserImageUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
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
        ),
        _loadGlobalSettingsUseCase(
          codes: [
            'file_allowed_types',
          ],
        ),
      ]);

      emit(
        state.copyWith(
          customer: requests[0] as Customer,
          user: requests[1] as User,
          profileConsoleSettings: requests[2] as List<GlobalSetting>,
        ),
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({ProfileBusyAction.load}),
        ),
      );

      if (state.user?.imageURL?.isNotEmpty ?? false) {
        await loadImage(imageURL: state.user!.imageURL!);
      }
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({ProfileBusyAction.load}),
          error: ProfileErrorStatus.generic,
        ),
      );
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
      var imageResponse = await _loadCustomerImageUseCase.call(
        imageURL: imageURL,
      );

      final image =
          imageResponse is Map ? base64Decode(imageResponse["image"]) : null;

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
          error: ProfileErrorStatus.image,
        ),
      );
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
