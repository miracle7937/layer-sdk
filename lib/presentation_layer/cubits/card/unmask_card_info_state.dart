import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the actions that can be performed by [UnmaskedCardInfoCubit]
enum UnmaskCardInfoAction {
  /// Loading the card info
  loadCardInfo,

  /// The second factor is being verified.
  verifySecondFactor,

  /// Getting the OTP ID
  gettingOTPId,

  /// The second factor is resending otp.
  resendSecondFactor,
}

/// The available events that the cubit can emit.
enum UnmaskCardInfoEvent {
  /// Event for inputting the second factor (biometrics/otp)
  inputSecondFactor,

  /// Event for closing the OTP code.
  closeOTPView,

  /// Event to show card info
  showCardInfo,
}

/// Represents the error codes that can be returned by [UnmaskedCardInfoCubit]
enum UnmaskCardInfoValidationErrorCode {
  /// Network error
  network,

  /// Generic error
  generic
}

/// Represents the state of [UnmaskCardInfoCubit]
class UnmaskCardInfoState extends BaseState<UnmaskCardInfoAction,
    UnmaskCardInfoEvent, UnmaskCardInfoValidationErrorCode> {
  /// The card info for the last selected card
  final CardInfo? cardInfo;

  /// The otp id
  final int? otpId;

  /// Client response for ocra flow
  final String? clientResponse;

  /// Creates a new instance of [CardState]
  UnmaskCardInfoState({
    this.cardInfo,
    this.otpId,
    this.clientResponse,
    Iterable<BankingCard> cards = const [],
    super.actions = const <UnmaskCardInfoAction>{},
    super.events = const <UnmaskCardInfoEvent>{},
    super.errors = const <CubitError>{},
  });

  @override
  List<Object?> get props => [
        actions,
        events,
        errors,
        cardInfo,
        otpId,
        clientResponse,
      ];

  /// Creates a new instance of [CardDashboardState] based
  /// on the current instance
  UnmaskCardInfoState copyWith({
    Set<UnmaskCardInfoAction>? actions,
    Set<UnmaskCardInfoEvent>? events,
    Set<CubitError>? errors,
    CardInfo? cardInfo,
    int? otpId,
    String? clientResponse,
  }) {
    return UnmaskCardInfoState(
      actions: actions ?? this.actions,
      events: events ?? super.events,
      errors: errors ?? this.errors,
      cardInfo: cardInfo,
      otpId: otpId ?? this.otpId,
      clientResponse: clientResponse ?? this.clientResponse,
    );
  }
}
