import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../utils.dart';

/// The available busy actions that the cubit can perform.
enum LoyaltyLandingActions {
  /// Loading all the loyalty points
  loadAllLoyaltyPoints,

  /// Loading the current loyalty rate points
  loadCurrentLoyaltyPoints,

  /// Loading the expired loyalty points
  loadExpiredLoyaltyPoints,

  /// Loading the offers
  loadOffers,
}

/// The state for the [LoyaltyLandingState].
class LoyaltyLandingState extends BaseState<LoyaltyLandingActions, void, void> {
  /// All the [LoyaltyPoints]
  final UnmodifiableListView<LoyaltyPoints> loyaltyPoints;

  /// All the [Offer]s
  final UnmodifiableListView<Offer> offers;

  /// The [LoyaltyPointsRate] object
  final LoyaltyPointsRate? loyaltyPointsRate;

  /// The [LoyaltyPointsExpiration] object
  final LoyaltyPointsExpiration? loyaltyPointsExpiration;

  /// Creates a new [LoyaltyLandingState] instance
  LoyaltyLandingState({
    super.actions = const <LoyaltyLandingActions>{},
    super.errors = const <CubitError>{},
    Iterable<LoyaltyPoints> loyaltyPoints = const <LoyaltyPoints>{},
    Iterable<Offer> offers = const <Offer>{},
    this.loyaltyPointsRate,
    this.loyaltyPointsExpiration,
  })  : loyaltyPoints = UnmodifiableListView(loyaltyPoints),
        offers = UnmodifiableListView(offers);

  @override
  LoyaltyLandingState copyWith({
    Set<LoyaltyLandingActions>? actions,
    Set<CubitError>? errors,
    Iterable<LoyaltyPoints>? loyaltyPoints,
    Iterable<Offer>? offers,
    LoyaltyPointsRate? loyaltyPointsRate,
    LoyaltyPointsExpiration? loyaltyPointsExpiration,
    Pagination? pagination,
  }) {
    return LoyaltyLandingState(
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyPointsRate: loyaltyPointsRate ?? this.loyaltyPointsRate,
      loyaltyPointsExpiration:
          loyaltyPointsExpiration ?? this.loyaltyPointsExpiration,
      offers: offers ?? this.offers,
    );
  }

  @override
  List<Object?> get props => [
        actions,
        errors,
        loyaltyPoints,
        loyaltyPointsRate,
        loyaltyPointsExpiration,
        offers,
      ];
}
