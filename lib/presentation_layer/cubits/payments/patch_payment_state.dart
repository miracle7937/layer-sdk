import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The state of the patch bill payment cubit
class PatchPaymentState
    extends BaseState<PatchPaymentAction, PatchPaymentEvent, void> {
  /// The payment to be patched
  final Payment payment;

  /// A list of accounts that the user has to select from in order to pay.
  final List<Account> fromAccounts;

  /// The initially selected account when we first open the screen.
  final Account? _initiallySelectedAccount;

  /// The initial amount of the payment when we first open the screen.
  final double? _initialAmount;

  /// The initial schedule details of the payment when we first open the screen
  final ScheduleDetails? _initialRecurrence;

  /// The details about scheduled payments
  final ScheduleDetails? scheduleDetails;

  /// The payment returned
  final Payment? returnedPayment;

  /// Creates a new state.
  PatchPaymentState({
    required this.payment,
    this.fromAccounts = const [],
    Account? initiallySelectedAccount,
    double? initialAmount,
    List<Biller> billers = const [],
    this.scheduleDetails,
    super.actions = const <PatchPaymentAction>{},
    super.errors = const <CubitError>{},
    super.events = const <PatchPaymentEvent>{},
    this.returnedPayment,
  })  : _initialRecurrence = scheduleDetails?.copyWith(),
        _initialAmount = initialAmount,
        _initiallySelectedAccount = initiallySelectedAccount;

  @override
  List<Object?> get props => [
        actions,
        events,
        errors,
        payment,
        _initiallySelectedAccount,
        _initialAmount,
        _initialRecurrence,
        fromAccounts,
        scheduleDetails,
        returnedPayment,
      ];

  /// Creates a new state based on this one.
  PatchPaymentState copyWith({
    Payment? payment,
    List<Account>? fromAccounts,
    ScheduleDetails? scheduleDetails,
    Set<CubitError>? errors,
    Set<PatchPaymentAction>? actions,
    Set<PatchPaymentEvent>? events,
    Payment? returnedPayment,
  }) =>
      PatchPaymentState(
        payment: payment ?? this.payment,
        fromAccounts: fromAccounts ?? this.fromAccounts,
        scheduleDetails: scheduleDetails ?? this.scheduleDetails,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        actions: actions ?? super.actions,
        returnedPayment: returnedPayment ?? this.returnedPayment,
      );

  /// Whether the user can submit the form or not
  bool get canSubmit =>
      (_initiallySelectedAccount?.id != payment.fromAccount?.id ||
          _initialAmount != payment.amount ||
          canSubmitRecurrence) &&
      payment.fromAccount != null &&
      ((payment.fromAccount?.availableBalance ?? 0) >= (payment.amount ?? 0)) &&
      (payment.amount ?? 0) > 0 &&
      (scheduleDetails?.recurrence == null ||
          scheduleDetails?.recurrence == Recurrence.none ||
          (scheduleDetails?.startDate != null || payment.scheduled != null));

  /// Whether the recurrence changed or not
  bool get canSubmitRecurrence =>
      _initialRecurrence?.recurrence != scheduleDetails?.recurrence
          ? true
          : _initialRecurrence?.startDate != scheduleDetails?.startDate;

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
  Payment get paymentToBePatched => payment.copyWith(
        recurrence: scheduleDetails?.recurrence,
        scheduled: _scheduledDate,
        recurring: _recurring,
        recurrenceStart: _recurrenceStart,
        recurrenceEnd: _recurrenceEnd,
      );
}

/// Which loading action the cubit is doing
enum PatchPaymentAction {
  /// Loading the entire cubit state
  loading,

  /// Submitting the payment
  submitting,

  /// Sending the OTP code for the payment.
  sendingOTPCode,

  /// Validating second factory
  verifyingSecondFactor,

  /// Re-sending the OTP
  resendingOTP,
}

/// Possible events
enum PatchPaymentEvent {
  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,

  /// Event for showing the payment result view.
  showResultView,
}
