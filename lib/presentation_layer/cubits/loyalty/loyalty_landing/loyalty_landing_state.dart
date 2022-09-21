import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../utils.dart';

enum LoyaltyLandingActions {
  allLoyaltyPoints,

  currentLoyaltyPoints,

  expiredLoyaltyPoints,

  offers,
}

enum LoyaltyLandingEvent { none }

enum LoyaltyLandingValidationErrorCode { none }

class LoyaltyLandingState extends BaseState<LoyaltyLandingActions,
    LoyaltyLandingEvent, LoyaltyLandingValidationErrorCode> {
  final UnmodifiableListView<LoyaltyPoints> loyaltyPoints;

  final UnmodifiableListView<Offer> offers;

  final LoyaltyPointsRate? loyaltyPointsRate;

  final LoyaltyPointsExpiration? loyaltyPointsExpiration;

  final Pagination pagination;

  LoyaltyLandingState({
    super.actions = const <LoyaltyLandingActions>{},
    super.errors = const <CubitError>{},
    super.events = const <LoyaltyLandingEvent>{},
    Iterable<LoyaltyPoints> loyaltyPoints = const <LoyaltyPoints>{},
    Iterable<Offer> offers = const <Offer>{},
    this.loyaltyPointsRate,
    this.loyaltyPointsExpiration,
    this.pagination = const Pagination(),
  })  : loyaltyPoints = UnmodifiableListView(loyaltyPoints),
        offers = UnmodifiableListView(offers);

  @override
  LoyaltyLandingState copyWith({
    Set<LoyaltyLandingActions>? actions,
    Set<CubitError>? errors,
    Set<LoyaltyLandingEvent>? events,
    Iterable<LoyaltyPoints>? loyaltyPoints,
    Iterable<Offer>? offers,
    LoyaltyPointsRate? loyaltyPointsRate,
    LoyaltyPointsExpiration? loyaltyPointsExpiration,
    Pagination? pagination,
  }) {
    return LoyaltyLandingState(
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
      events: events ?? this.events,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyPointsRate: loyaltyPointsRate ?? this.loyaltyPointsRate,
      loyaltyPointsExpiration:
          loyaltyPointsExpiration ?? this.loyaltyPointsExpiration,
      pagination: pagination ?? this.pagination,
      offers: offers ?? this.offers,
    );
  }

  @override
  List<Object?> get props => [
        actions,
        errors,
        events,
        loyaltyPoints,
        loyaltyPointsRate,
        loyaltyPointsExpiration,
        pagination,
        offers,
      ];
}
