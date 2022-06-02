import 'package:bloc/bloc.dart';
import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

///A cubit that holds a single offer data.
class OfferDetailsCubit extends Cubit<OfferDetailsState> {
  final LoadOfferByIdUseCase _loadOfferById;

  /// Creates a new [OfferDetailsCubit] providing an [OfferRepository]
  OfferDetailsCubit({
    required LoadOfferByIdUseCase loadOfferById,
    required int offerId,
  })  : _loadOfferById = loadOfferById,
        super(
          OfferDetailsState(
            offerId: offerId,
          ),
        );

  /// Fetches the offer details
  ///
  /// The [latitude] and the [longitude] fields are used
  /// for calculating the offer's distance.
  Future<void> load({
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
  }) async {
    assert((latitude == null && longitude == null) ||
        (latitude != null && longitude != null));

    emit(
      state.copyWith(
        busy: true,
        error: OfferDetailsStateError.none,
      ),
    );

    try {
      final offer = await _loadOfferById(
        offerId: state.offerId,
        forceRefresh: forceRefresh,
        latitude: latitude,
        longitude: longitude,
      );

      emit(
        state.copyWith(
          busy: false,
          offer: offer,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? OfferDetailsStateError.network
              : OfferDetailsStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
