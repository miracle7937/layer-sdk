import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../layer_sdk.dart';
import 'loyalty_landing_state.dart';

///
class LoyaltyLandingCubit extends Cubit<LoyaltyLandingState> {
  final LoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;
  final LoadCurrentLoyaltyPointsRateUseCase
      _loadCurrentLoyaltyPointsRateUseCase;
  final LoadExpiredLoyaltyPointsByDateUseCase
      _loadExpiredLoyaltyPointsByDateUseCase;
  final LoadOffersUseCase _loadOffersUseCase;

  ///
  LoyaltyLandingCubit({
    required LoadAllLoyaltyPointsUseCase loadAllLoyaltyPointsUseCase,
    required LoadCurrentLoyaltyPointsRateUseCase
        loadCurrentLoyaltyPointsRateUseCase,
    required LoadExpiredLoyaltyPointsByDateUseCase
        loadExpiredLoyaltyPointsByDateUseCase,
    required LoadOffersUseCase loadOffersUseCase,
    int limit = 20,
  })  : _loadAllLoyaltyPointsUseCase = loadAllLoyaltyPointsUseCase,
        _loadCurrentLoyaltyPointsRateUseCase =
            loadCurrentLoyaltyPointsRateUseCase,
        _loadExpiredLoyaltyPointsByDateUseCase =
            loadExpiredLoyaltyPointsByDateUseCase,
        _loadOffersUseCase = loadOffersUseCase,
        super(LoyaltyLandingState(
          pagination: Pagination(limit: limit),
        ));

  ///
  Future<void> initialize({
    required DateTime expirationDate,
  }) async {
    await Future.wait([
      _loadAllLoyaltyPoints(),
      _loadCurrentLoyaltyPointsRate(),
      _loadExpiredLoyaltyPoints(
        expirationDate: expirationDate,
      ),
      _loadOffers(),
    ]);
  }

  Future<void> _loadAllLoyaltyPoints() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.allLoyaltyPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.allLoyaltyPoints,
        ),
      ),
    );

    try {
      final loyaltyPoints = await _loadAllLoyaltyPointsUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.allLoyaltyPoints,
          ),
          loyaltyPoints: loyaltyPoints,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.allLoyaltyPoints),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.allLoyaltyPoints,
          exception: e,
        ),
      ));
    }
  }

  Future<void> _loadCurrentLoyaltyPointsRate() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.currentLoyaltyPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.currentLoyaltyPoints,
        ),
      ),
    );

    try {
      final loyaltyPointsRate = await _loadCurrentLoyaltyPointsRateUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyLandingActions.currentLoyaltyPoints,
          ),
          loyaltyPointsRate: loyaltyPointsRate,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.currentLoyaltyPoints),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.currentLoyaltyPoints,
          exception: e,
        ),
      ));
    }
  }

  Future<void> _loadExpiredLoyaltyPoints({
    required DateTime expirationDate,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyLandingActions.expiredLoyaltyPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.expiredLoyaltyPoints,
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
            LoyaltyLandingActions.expiredLoyaltyPoints,
          ),
          loyaltyPointsExpiration: loyaltyPointsExpiration,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.expiredLoyaltyPoints),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.expiredLoyaltyPoints,
          exception: e,
        ),
      ));
    }
  }

  Future<void> _loadOffers({
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
          LoyaltyLandingActions.offers,
        ),
        errors: state.removeErrorForAction(
          LoyaltyLandingActions.offers,
        ),
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

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
            LoyaltyLandingActions.offers,
          ),
          offers: offers,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: result.offers.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(LoyaltyLandingActions.offers),
        errors: state.addErrorFromException(
          action: LoyaltyLandingActions.offers,
          exception: e,
        ),
      ));
    }
  }
}
