import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';

import '../../cubits.dart';

///A cubit that holds a single offer data.
class OfferDetailsCubit extends Cubit<OfferDetailsState> {
  final OfferRepository _repository;

  /// Creates a new [OfferDetailsCubit] providing an [OfferRepository]
  OfferDetailsCubit({
    required OfferRepository repository,
    required int offerId,
  })  : _repository = repository,
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
      final offer = await _repository.getOffer(
        id: state.offerId,
        forceRefresh: forceRefresh,
        latitudeForDistance: latitude,
        longitudeForDistance: longitude,
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
