import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// The available actions the cubit can emit.
enum UnmaskCardInfoAction {
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
enum UnmaskCardInfoEvent {
  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,
}

/// The state for the [UnmaskCardInfoCubit]
class UnmaskCardInfoState
    extends BaseState<UnmaskCardInfoAction, UnmaskCardInfoEvent, void> {
  /// The card info object.
  final CardInfo? cardInfo;

  /// Creates a new instance of [UnmaskCardInfoState]
  UnmaskCardInfoState({
    this.cardInfo,
    super.actions = const <UnmaskCardInfoAction>{},
    super.events = const <UnmaskCardInfoEvent>{},
    super.errors = const <CubitError>{},
  });

  /// Creates a copy of this [UnmaskCardInfoState] with the passed values.
  UnmaskCardInfoState copyWith({
    Set<UnmaskCardInfoAction>? actions,
    Set<UnmaskCardInfoEvent>? events,
    Set<CubitError>? errors,
    CardInfo? cardInfo,
  }) =>
      UnmaskCardInfoState(
        actions: actions ?? this.actions,
        events: events ?? super.events,
        errors: errors ?? this.errors,
        cardInfo: cardInfo ?? this.cardInfo,
      );

  @override
  List<Object?> get props => [
        actions,
        events,
        errors,
        cardInfo,
      ];
}
