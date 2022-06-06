import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// The available errors.
enum OfferDetailsStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

///The state of the offer details cubit
class OfferDetailsState extends Equatable {
  /// The offerId
  final int offerId;

  /// The offer
  final Offer? offer;

  /// If the cubit is processing something for this offer
  final bool busy;

  /// The current error
  final OfferDetailsStateError error;

  /// Holds the error message returned from the API
  final String? errorMessage;

  ///Creates a new [OfferDetailsState]
  OfferDetailsState({
    required this.offerId,
    this.offer,
    this.busy = false,
    this.error = OfferDetailsStateError.none,
    this.errorMessage,
  });

  ///Copies the object with new values
  OfferDetailsState copyWith({
    int? offerId,
    Offer? offer,
    bool? busy,
    OfferDetailsStateError? error,
    String? errorMessage,
  }) =>
      OfferDetailsState(
        offerId: offerId ?? this.offerId,
        offer: offer ?? this.offer,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == OfferDetailsStateError.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        offerId,
        offer,
        busy,
        error,
        errorMessage,
      ];
}
