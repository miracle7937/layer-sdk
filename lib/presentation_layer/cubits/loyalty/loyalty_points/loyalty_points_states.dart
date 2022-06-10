import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';
import '../../../utils.dart';

///  The available error status
enum LoyaltyPointsErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,

  ///  No loyalty found
  noData,
}

/// State container for [LoyaltyPointsCubit]
class LoyaltyPointsState extends Equatable {
  /// The [LoyaltyPoints] model
  final LoyaltyPoints loyaltyPoints;

  /// True if the cubit is processing
  final bool busy;

  /// Current error status
  final LoyaltyPointsErrorStatus errorStatus;

  /// Creates a new [LoyaltyPointsState].
  LoyaltyPointsState({
    this.loyaltyPoints = const LoyaltyPoints(id: -1),
    this.busy = false,
    this.errorStatus = LoyaltyPointsErrorStatus.none,
  });

  /// Clone this object, with different values
  LoyaltyPointsState copyWith({
    LoyaltyPoints? loyaltyPoints,
    bool? busy,
    Pagination? pagination,
    LoyaltyPointsErrorStatus? errorStatus,
  }) =>
      LoyaltyPointsState(
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
      );

  @override
  List<Object?> get props => [
        loyaltyPoints,
        busy,
        errorStatus,
      ];
}
