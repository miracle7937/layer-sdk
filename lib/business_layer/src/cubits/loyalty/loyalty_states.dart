import 'package:equatable/equatable.dart';
import '../../../../data_layer/data_layer.dart';
import '../../utils/pagination.dart';

///  The available error status
enum LoyaltyErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,

  ///  No loyalty found
  noData,
}

/// State container for [LoyaltyCubit]
class LoyaltyState extends Equatable {
  /// The [Loyalty] model
  final Loyalty loyalty;

  /// True if the cubit is processing
  final bool busy;

  /// Current error status
  final LoyaltyErrorStatus errorStatus;

  /// Creates a new [LoyaltyState].
  LoyaltyState({
    this.loyalty = const Loyalty(id: -1),
    this.busy = false,
    this.errorStatus = LoyaltyErrorStatus.none,
  });

  @override
  List<Object?> get props => [
        loyalty,
        busy,
        errorStatus,
      ];

  /// Clone this object, with different values
  LoyaltyState copyWith({
    Loyalty? loyalty,
    bool? busy,
    Pagination? pagination,
    LoyaltyErrorStatus? errorStatus,
  }) {
    return LoyaltyState(
      loyalty: loyalty ?? this.loyalty,
      busy: busy ?? this.busy,
      errorStatus: errorStatus ?? this.errorStatus,
    );
  }
}
