import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../extensions.dart';
import 'branding_state.dart';

/// Cubit responsible for the branding data.
class BrandingCubit extends Cubit<BrandingState> {
  final LoadBrandingUseCase _getBrandingUseCase;

  /// Creates a new instance of [BrandingCubit]
  BrandingCubit({
    required LoadBrandingUseCase getBrandingUseCase,
  })  : _getBrandingUseCase = getBrandingUseCase,
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
      final branding = await _getBrandingUseCase(
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
    } on Exception catch (e, st) {
      logException(e, st);
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
