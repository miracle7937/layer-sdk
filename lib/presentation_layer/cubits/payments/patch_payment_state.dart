import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/models/payment/biller.dart';

/// Which loading action the cubit is doing
enum PatchPaymentBusyAction {
  /// Loading the entire cubit state
  loading,

  /// Loading the list of services
  loadingServices,

  /// Submitting the payment
  submitting,

  /// Validating second factory
  validatingSecondFactor,

  /// Re-sending the OTP
  resendingOTP,

  /// Validating user input
  validating,
}

/// The available error status
enum PatchPaymentErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the patch bill payment cubit
class PatchPaymentState extends Equatable {
  /// The payment to be patched
  final Payment payment;

  /// A list of accounts that the user has to select from in order to pay.
  final List<Account> fromAccounts;

  /// The initially selected account when we first open the screen.
  final Account? initiallySelectedAccount;

  /// The initial amount of the payment when we first open the screen.
  final double? initialAmount;

  /// The initial schedule details of the payment when we first open the screen
  final ScheduleDetails? initialRecurrence;

  /// True if the cubit is processing something.
  final bool busy;

  /// Which busy action is the cubit doing
  final PatchPaymentBusyAction busyAction;

  /// The current error status.
  final PatchPaymentErrorStatus errorStatus;

  /// The details about scheduled payments
  final ScheduleDetails? scheduleDetails;

  /// Creates a new state.
  PatchPaymentState({
    required this.payment,
    this.fromAccounts = const [],
    this.initiallySelectedAccount,
    this.initialAmount,
    this.initialRecurrence,
    List<Biller> billers = const [],
    this.busy = true,
    this.busyAction = PatchPaymentBusyAction.loading,
    this.errorStatus = PatchPaymentErrorStatus.none,
    this.scheduleDetails,
  });

  @override
  List<Object?> get props => [
        payment,
        initiallySelectedAccount,
        initialAmount,
        initialRecurrence,
        fromAccounts,
        busy,
        busyAction,
        errorStatus,
        scheduleDetails,
      ];

  /// Creates a new state based on this one.
  PatchPaymentState copyWith({
    Payment? payment,
    Account? initiallySelectedAccount,
    double? initialAmount,
    ScheduleDetails? initialRecurrence,
    List<Account>? fromAccounts,
    bool? busy,
    PatchPaymentErrorStatus? errorStatus,
    PatchPaymentBusyAction? busyAction,
    ScheduleDetails? scheduleDetails,
  }) {
    return PatchPaymentState(
      payment: payment ?? this.payment,
      initiallySelectedAccount:
          initiallySelectedAccount ?? this.initiallySelectedAccount,
      initialAmount: initialAmount ?? this.initialAmount,
      initialRecurrence: initialRecurrence ?? this.initialRecurrence,
      fromAccounts: fromAccounts ?? this.fromAccounts,
      busy: busy ?? this.busy,
      busyAction: busyAction ?? this.busyAction,
      errorStatus: errorStatus ?? this.errorStatus,
      scheduleDetails: scheduleDetails ?? this.scheduleDetails,
    );
  }

  /// Whether the user can submit the form or not
  bool get canSubmit =>
      !busy &&
      (initiallySelectedAccount?.id != payment.fromAccount?.id ||
          initialAmount != payment.amount ||
          canSubmitRecurrence) &&
      payment.fromAccount != null &&
      ((payment.fromAccount?.availableBalance ?? 0) >= (payment.amount ?? 0)) &&
      (payment.amount ?? 0) > 0 &&
      (scheduleDetails?.recurrence == null ||
          scheduleDetails?.recurrence == Recurrence.none ||
          scheduleDetails?.startDate != null);

  /// Whether the recurrence changed or not
  bool get canSubmitRecurrence =>
      initialRecurrence?.recurrence != scheduleDetails?.recurrence
          ? true
          : initialRecurrence?.startDate != scheduleDetails?.startDate;

  bool get _schedueled => scheduleDetails?.recurrence == Recurrence.once;
  bool get _recurring => ![
        Recurrence.once,
        Recurrence.none,
        null,
      ].contains(scheduleDetails?.recurrence);

  DateTime? get _recurrenceStart =>
      _recurring ? scheduleDetails?.startDate : null;

  DateTime? get _recurrenceEnd => _recurring ? scheduleDetails?.endDate : null;

  DateTime? get _scheduledDate =>
      _schedueled ? scheduleDetails?.startDate : null;

  /// The payment to be patched
  Payment get paymentToBePatched => Payment(
        fromAccount: payment.fromAccount,
        bill: payment.bill,
        amount: payment.amount,
        currency: payment.fromAccount?.currency ?? '',
        deviceUID: payment.deviceUID,
        status: PaymentStatus.completed,
        recurrence: payment.recurrence,
        scheduled: _scheduledDate,
        recurrenceStart: _recurrenceStart,
        recurrenceEnd: _recurrenceEnd,
      );
}
