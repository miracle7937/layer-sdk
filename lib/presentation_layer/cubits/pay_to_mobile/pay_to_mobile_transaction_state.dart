import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available actions.
enum PayToMobileTransactionAction {
  /// Resending the withdrawal code.
  resendWithdrawalCode,

  /// Deleting the pay to mobile.
  delete,

  /// Sending OTP code.
  sendOTPCode,

  /// Verifying second factor.
  verifySecondFactor,

  /// Resending second factor.
  resendSecondFactor,
}

/// The available events.
enum PayToMobileTransactionEvent {
  /// Open second factor.
  openSecondFactor,

  /// Show OTP code view.
  showOTPCodeView,

  /// Close second factor.
  closeSecondFactor,

  /// Close details bottom sheet and reload.
  closeAndReload,
}

/// Holds the state for the [PayToMobileTransactionCubit].
class PayToMobileTransactionState extends BaseState<
    PayToMobileTransactionAction, PayToMobileTransactionEvent, void> {
  /// The pay to mobile obtained while deleting a pay to mobile.
  final PayToMobile? deletePayToMobileResult;

  /// Creates a new [PayToMobileTransactionState].
  PayToMobileTransactionState({
    super.actions = const <PayToMobileTransactionAction>{},
    super.errors = const <CubitError>{},
    super.events = const <PayToMobileTransactionEvent>{},
    this.deletePayToMobileResult,
  });

  @override
  PayToMobileTransactionState copyWith({
    Set<PayToMobileTransactionAction>? actions,
    Set<CubitError>? errors,
    Set<PayToMobileTransactionEvent>? events,
    PayToMobile? deletePayToMobileResult,
  }) =>
      PayToMobileTransactionState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        deletePayToMobileResult:
            deletePayToMobileResult ?? this.deletePayToMobileResult,
      );

  @override
  List<Object?> get props => [
        actions,
        events,
        errors,
        deletePayToMobileResult,
      ];
}
