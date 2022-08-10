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

  /// True if the cubit is processing something.
  final bool busy;

  /// Which busy action is the cubit doing
  final PatchPaymentBusyAction busyAction;

  /// The current error status.
  final PatchPaymentErrorStatus errorStatus;

  /// The details about scheduled payments
  final ScheduleDetails? scheduleDetails;

  /// Whether if the payment should be saved to a shortcut.
  /// Default is `false`
  final bool saveToShortcut;

  /// The shortcut name.
  final String? shortcutName;

  /// Creates a new state.
  PatchPaymentState({
    required this.payment,
    this.fromAccounts = const [],
    List<Biller> billers = const [],
    this.busy = true,
    this.busyAction = PatchPaymentBusyAction.loading,
    this.errorStatus = PatchPaymentErrorStatus.none,
    this.scheduleDetails,
    this.saveToShortcut = false,
    this.shortcutName,
  });

  @override
  List<Object?> get props => [
        payment,
        fromAccounts,
        busy,
        busyAction,
        errorStatus,
        scheduleDetails,
        saveToShortcut,
        shortcutName,
      ];

  /// Creates a new state based on this one.
  PatchPaymentState copyWith({
    Payment? payment,
    List<Account>? fromAccounts,
    bool? busy,
    PatchPaymentErrorStatus? errorStatus,
    PatchPaymentBusyAction? busyAction,
    ScheduleDetails? scheduleDetails,
    bool? saveToShortcut,
    String? shortcutName,
  }) {
    return PatchPaymentState(
      payment: payment ?? this.payment,
      fromAccounts: fromAccounts ?? this.fromAccounts,
      busy: busy ?? this.busy,
      busyAction: busyAction ?? this.busyAction,
      errorStatus: errorStatus ?? this.errorStatus,
      scheduleDetails: scheduleDetails ?? this.scheduleDetails,
      saveToShortcut: saveToShortcut ?? this.saveToShortcut,
      shortcutName: !(saveToShortcut ?? this.saveToShortcut)
          ? null
          : (shortcutName ?? this.shortcutName),
    );
  }

  /// Whether the user can submit the form or not
  bool get canSubmit =>
      !busy &&
      payment.fromAccount != null &&
      (payment.amount ?? 0) > 0 &&
      (!saveToShortcut || (shortcutName?.isNotEmpty ?? false)) &&
      (scheduleDetails?.recurrence == null ||
          scheduleDetails?.recurrence == Recurrence.none ||
          scheduleDetails?.startDate != null);

  bool get _scheduled => scheduleDetails?.recurrence == Recurrence.once;
  bool get _recurring => ![
        Recurrence.once,
        Recurrence.none,
        null,
      ].contains(scheduleDetails?.recurrence);

  DateTime? get _recurrenceStart =>
      _recurring ? scheduleDetails?.startDate : null;

  DateTime? get _recurrenceEnd => _recurring ? scheduleDetails?.endDate : null;

  DateTime? get _scheduledDate =>
      _scheduled ? scheduleDetails?.startDate : null;

  /// The payment to be patched
  Payment get paymentToBePatched => Payment(
        fromAccount: payment.fromAccount,
        bill: payment.bill,
        amount: payment.amount,
        currency: payment.fromAccount?.currency ?? '',
        deviceUID: payment.deviceUID,
        status: PaymentStatus.completed,
        recurrence: scheduleDetails?.recurrence ?? Recurrence.none,
        scheduled: _scheduledDate,
        recurrenceStart: _recurrenceStart,
        recurrenceEnd: _recurrenceEnd,
      );
}
