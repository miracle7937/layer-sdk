import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../layer_sdk.dart';

/// Cubit responsible for Landing loyalty page
class LoyaltyLandingCubit extends Cubit<LoyaltyLandingState> {
  final LoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;
  final LoadCurrentLoyaltyPointsRateUseCase
      _loadCurrentLoyaltyPointsRateUseCase;
  final LoadExpiredLoyaltyPointsByDateUseCase
      _loadExpiredLoyaltyPointsByDateUseCase;
  final LoadOffersUseCase _loadOffersUseCase;
  final LoadCategoriesUseCase _loadCategoriesUseCase;
  final Pagination _pagination;

  /// Creates a new [LoyaltyLandingCubit] using the suplied use cases
  LoyaltyLandingCubit({
    required LoadAllLoyaltyPointsUseCase loadAllLoyaltyPointsUseCase,
    required LoadCurrentLoyaltyPointsRateUseCase
        loadCurrentLoyaltyPointsRateUseCase,
    required LoadExpiredLoyaltyPointsByDateUseCase
        loadExpiredLoyaltyPointsByDateUseCase,
    required LoadOffersUseCase loadOffersUseCase,
    required LoadCategoriesUseCase loadCategoriesUseCase,
    int limit = 20,
  })  : _loadAllLoyaltyPointsUseCase = loadAllLoyaltyPointsUseCase,
        _loadCurrentLoyaltyPointsRateUseCase =
            loadCurrentLoyaltyPointsRateUseCase,
        _loadExpiredLoyaltyPointsByDateUseCase =
            loadExpiredLoyaltyPointsByDateUseCase,
        _loadOffersUseCase = loadOffersUseCase,
        _loadCategoriesUseCase = loadCategoriesUseCase,
        _pagination = Pagination(limit: limit),
        super(LoyaltyLandingState());

  /// Initialize / loads all necessary data for the landing screen
  Future<void> initialize({
    required DateTime expirationDate,
  }) async {
    await Future.wait([
      loadAllLoyaltyPoints(),
      loadCurrentLoyaltyPointsRate(),
      loadExpiredLoyaltyPoints(
        expirationDate: expirationDate,
      ),
      loadOffers(),
      loadCategories(),
    ]);
  }

  /// Loads all loyalty points
  Future<void> loadAllLoyaltyPoints() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.loadAllLoyaltyPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.loadAllLoyaltyPoints,
        ),
      ),
    );

    try {
      final loyaltyPoints = await _loadAllLoyaltyPointsUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.loadAllLoyaltyPoints,
          ),
          loyaltyPoints: loyaltyPoints,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.loadAllLoyaltyPoints),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.loadAllLoyaltyPoints,
          exception: e,
        ),
      ));
    }
  }

  /// Loads the current rate of loyalty points
  Future<void> loadCurrentLoyaltyPointsRate() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.loadCurrentLoyaltyPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.loadCurrentLoyaltyPoints,
        ),
      ),
    );

    try {
      final loyaltyPointsRate = await _loadCurrentLoyaltyPointsRateUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.loadCurrentLoyaltyPoints,
          ),
          loyaltyPointsRate: loyaltyPointsRate,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(
          LoyaltyLandingActions.loadCurrentLoyaltyPoints,
        ),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.loadCurrentLoyaltyPoints,
          exception: e,
        ),
      ));
    }
  }

  /// Loads the expired loyalty point from `expirationDate` param
  Future<void> loadExpiredLoyaltyPoints({
    required DateTime expirationDate,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.loadExpiredLoyaltyPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.loadExpiredLoyaltyPoints,
        ),
      ),
    );

    try {
      final loyaltyPointsExpiration =
          await _loadExpiredLoyaltyPointsByDateUseCase(
        expirationDate: expirationDate,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.loadExpiredLoyaltyPoints,
          ),
          loyaltyPointsExpiration: loyaltyPointsExpiration,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(
          LoyaltyLandingActions.loadExpiredLoyaltyPoints,
        ),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.loadExpiredLoyaltyPoints,
          exception: e,
        ),
      ));
    }
  }

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
  Future<void> loadOffers({
    bool loadMore = false,
    List<int>? ids,
    List<int>? categories,
    DateTime? fromDate,
    DateTime? toDate,
    double? latitudeForDistance,
    double? longitudeForDistance,
    double? latitude,
    double? longitude,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.loadOffers,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.loadOffers,
        ),
      ),
    );

    try {
      final newPage = _pagination.paginate(loadMore: loadMore);

      final result = await _loadOffersUseCase(
        offset: newPage.offset,
        limit: newPage.limit,
        ids: ids,
        from: fromDate,
        to: toDate,
        categories: categories,
        latitudeForDistance: latitudeForDistance,
        longitudeForDistance: longitudeForDistance,
        latitude: latitude,
        longitude: longitude,
      );

      final offers = newPage.firstPage
          ? result.offers
          : [
              ...state.offers,
              ...result.offers,
            ];

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.loadOffers,
          ),
          offers: offers,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: result.offers.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.loadOffers),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.loadOffers,
          exception: e,
        ),
      ));
    }
  }

  /// Loads all categories
  Future<void> loadCategories() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.loadCategories,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.loadCategories,
        ),
      ),
    );

    try {
      final categories = await _loadCategoriesUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.loadCategories,
          ),
          categories: categories,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.loadCategories),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.loadCategories,
          exception: e,
        ),
      ));
    }
  }

  /// Getter method to check if there is more data to me loaded
  bool get canLoadMore => _pagination.canLoadMore;
}
