import 'dart:math';

import 'package:bloc/bloc.dart';
import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../utils.dart';

/// An [OfferCubit] for all the offers.
class AllOffersCubit extends OfferCubit {
  /// Creates a new [AllOffersCubit].
  AllOffersCubit({
    required LoadOffers loadOffers,
    required RewardType rewardType,
    int limit = 10,
  }) : super(
          loadOffers: loadOffers,
          offerStateType: OfferStateType.all,
          rewardType: rewardType,
          limit: limit,
        );
}

/// An [OfferCubit] for the offers target at the current user.
class ForMeOffersCubit extends OfferCubit {
  /// Creates a new [ForMeOffersCubit].
  ForMeOffersCubit({
    required LoadOffersForMe loadOffersForMe,
    required RewardType rewardType,
    int limit = 10,
  }) : super(
          loadOffers: loadOffersForMe,
          offerStateType: OfferStateType.forMe,
          rewardType: rewardType,
          limit: limit,
        );
}

/// An [OfferCubit] for the Favorite offers.
class FavoriteOffersCubit extends OfferCubit {
  /// Creates a new [FavoriteOffersCubit].
  FavoriteOffersCubit({
    required LoadFavoriteOffers loadFavoriteOffers,
    required RewardType rewardType,
    int limit = 10,
  }) : super(
          loadOffers: loadFavoriteOffers,
          offerStateType: OfferStateType.favorites,
          rewardType: rewardType,
          limit: limit,
        );
}

/// Holds offers data for a specific type (all, for me, favorites, or map).
/// The more specialized classes are the ones who set this type.
/// This is done to make it easier to use the cubits on a screen that has
/// all the types.
class OfferCubit extends Cubit<OfferState> {
  final LoadOffers _loadOffers;

  /// Creates a new [OfferCubit].
  OfferCubit({
    required LoadOffers loadOffers,
    required OfferStateType offerStateType,
    required RewardType rewardType,
    required int limit,
  })  : _loadOffers = loadOffers,
        super(
          OfferState(
            type: offerStateType,
            rewardType: rewardType,
            pagination: Pagination(
              limit: limit,
            ),
          ),
        );

  /// Loads the offers
  ///
  /// The [loadMore] value will load the next offers page if true.
  ///
  /// The [latitudeForDistance] and the [longitudeForDistance] fields are used
  /// for calculating each offer's distance.
  ///
  /// When indicating the [latitudeForDistance] and the [longitudeForDistance]
  /// fields you can also indicate the [latitude] and [longitude] fields
  /// which can be used for listing the offers starting from this location.
  /// So the offers will be sorted from nearest to farthest relative to the
  /// passed distance fields.
  ///
  /// Use cases:
  ///   - Listing the nearest offers to the camera position in a map.
  ///
  /// When not indicated, these fields will be equal to the passed
  /// distance fields.
  Future<void> load({
    List<int>? ids,
    List<int>? categories,
    DateTime? fromDate,
    DateTime? toDate,
    double? latitudeForDistance,
    double? longitudeForDistance,
    double? latitude,
    double? longitude,
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    assert((latitudeForDistance == null && longitudeForDistance == null) ||
        (latitudeForDistance != null && longitudeForDistance != null));

    emit(
      state.copyWith(
        busy: true,
        error: OfferStateError.none,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final response = await _loadOffers(
        ids: ids,
        rewardType: state.rewardType,
        offset: newPage.offset,
        limit: newPage.limit,
        forceRefresh: forceRefresh,
        from: fromDate,
        to: toDate,
        categories: categories,
        latitudeForDistance: latitudeForDistance,
        longitudeForDistance: longitudeForDistance,
        latitude: latitude,
        longitude: longitude,
      );

      Iterable<Offer> offers = newPage.firstPage
          ? response.offers
          : [
              ...state.offers,
              ...response.offers,
            ];

      emit(
        state.copyWith(
          offers: offers,
          total: max(response.totalCount, offers.length),
          busy: false,
          pagination: newPage.copyWith(
            canLoadMore: offers.length < response.totalCount,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? OfferStateError.network
              : OfferStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
