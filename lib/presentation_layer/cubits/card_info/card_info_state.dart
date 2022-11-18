import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// The available actions the cubit can emit.
enum CardInfoAction {
  /// Loading the card info
  loadCardInfo,

  /// Sending the OTP code for the transfer.
  sendOTPCode,

  /// The second factor is being verified.
  verifySecondFactor,

  /// The second factor is resending otp.
  resendSecondFactor,
}

/// The available events that the cubit can emit.
enum CardInfoEvent {
  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,

  /// Event for showing the card info view.
  showCardInfoView,
}

/// The state for the [CardInfoCubit].
class CardInfoState extends BaseState<CardInfoAction, CardInfoEvent, void> {
  /// The card info object.
  final CardInfo? cardInfo;

  /// Creates a new instance of [CardInfoState]
  CardInfoState({
    this.cardInfo,
    super.actions = const <CardInfoAction>{},
    super.events = const <CardInfoEvent>{},
    super.errors = const <CubitError>{},
  });

  /// Creates a copy of this [CardInfoState] with the passed values.
  CardInfoState copyWith({
    Set<CardInfoAction>? actions,
    Set<CardInfoEvent>? events,
    Set<CubitError>? errors,
    CardInfo? cardInfo,
    bool clearCardInfo = false,
  }) =>
      CardInfoState(
        actions: actions ?? this.actions,
        events: events ?? super.events,
        errors: errors ?? this.errors,
        cardInfo: clearCardInfo ? null : cardInfo ?? this.cardInfo,
      );

  @override
  List<Object?> get props => [
        actions,
        events,
        errors,
        cardInfo,
      ];
}
