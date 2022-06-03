import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'branding_states.dart';

/// Cubit responsible for the branding data.
class BrandingCubit extends Cubit<BrandingState> {
  final BrandingRepository _repository;

  /// Creates a new instance of [BrandingCubit]
  BrandingCubit({
    required BrandingRepository repository,
  })  : _repository = repository,
        super(BrandingState());

  /// Loads the branding.
  ///
  /// If [defaultBranding] is `true`, will default to the Layer branding,
  Future<void> load({
    bool defaultBranding = false,
    bool forceRefresh = true,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: BrandingStateErrors.none,
        action: BrandingStateActions.none,
      ),
    );

    try {
      final branding = await _repository.getBranding(
        forceDefault: defaultBranding,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          branding: branding,
          busy: false,
          action: BrandingStateActions.newBranding,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: BrandingStateErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
