import 'dart:collection';

import 'package:equatable/equatable.dart';
import '../../../../data_layer/data_layer.dart';

import '../../utils.dart';

/// The kind of offers we want to fetch.
enum OfferStateType {
  /// All offers.
  all,

  /// Only offers available to the user.
  forMe,

  /// The user's favorite offers.
  favorites,
}

/// The available errors.
enum OfferStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// The state of the offers cubit
class OfferState extends Equatable {
  /// The type of this state's offers.
  final OfferStateType type;

  /// The [RewardType] for the listed offers.
  final RewardType rewardType;

  /// The offers.
  final UnmodifiableListView<Offer> offers;

  /// The total count of offers available.
  ///
  /// This may differ from the count of the [offers] list.
  final int total;

  /// If it's busy doing something.
  final bool busy;

  /// Holds the current error
  final OfferStateError error;

  /// Holds the error message
  final String? errorMessage;

  /// Holds the pagination data.
  final Pagination pagination;

  /// Creates a new [OfferState].
  OfferState({
    required this.type,
    required this.rewardType,
    Iterable<Offer> offers = const <Offer>[],
    this.total = 0,
    this.busy = false,
    this.error = OfferStateError.none,
    this.errorMessage,
    this.pagination = const Pagination(limit: 10),
  }) : offers = UnmodifiableListView(offers);

  /// Copies the object with different values.
  OfferState copyWith({
    OfferStateType? type,
    RewardType? rewardType,
    Iterable<Offer>? offers,
    int? total,
    bool? busy,
    OfferStateError? error,
    String? errorMessage,
    Pagination? pagination,
  }) =>
      OfferState(
        type: type ?? this.type,
        rewardType: rewardType ?? this.rewardType,
        offers: offers ?? this.offers,
        total: total ?? this.total,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == OfferStateError.none
            ? null
            : (errorMessage ?? this.errorMessage),
        pagination: pagination ?? this.pagination,
      );

  @override
  List<Object?> get props => [
        type,
        rewardType,
        offers,
        total,
        busy,
        error,
        errorMessage,
        pagination,
      ];
}
