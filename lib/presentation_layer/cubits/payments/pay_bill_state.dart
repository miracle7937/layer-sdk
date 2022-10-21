import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// The state of the bill payment cubit
class PayBillState extends BaseState<PayBillBusyAction, PayBillEvent, void> {
  /// The amount to be paid
  final double amount;

  /// A list of accounts that the user has to select from in order to pay.
  final List<Account> fromAccounts;

  /// The account that the user selected to pay from.
  final Account? selectedAccount;

  /// A unique identifier of the payment.
  final String? deviceUID;

  /// A list of biller categories for the user to filter the billers with.
  final List<BillerCategory> billerCategories;

  /// The biller that the user selected to pay for.
  final Biller? selectedBiller;

  /// The category of billers the user has selected to filter by.
  final BillerCategory? selectedCategory;

  /// Contains all the billers coming from the BE
  final List<Biller> _billers;

  /// A list of biller services that the user has to select from in order
  /// to pay.
  final List<Service> services;

  /// The service that the user has selected to pay.
  final Service? selectedService;

  /// The service fields to display and input
  final List<ServiceField> serviceFields;

  /// The validated bill
  final Bill? validatedBill;

  /// The details about scheduled payments
  final ScheduleDetails? scheduleDetails;

  /// Whether if the payment should be saved to a shortcut.
  /// Default is `false`
  final bool saveToShortcut;

  /// The shortcut name.
  final String? shortcutName;

  /// The payment returned
  final Payment? returnedPayment;

  /// Creates a new state.
  PayBillState({
    this.amount = 0,
    super.actions = const <PayBillBusyAction>{},
    super.errors = const <CubitError>{},
    super.events = const <PayBillEvent>{},
    this.fromAccounts = const [],
    this.selectedAccount,
    this.deviceUID,
    this.billerCategories = const [],
    this.selectedBiller,
    this.selectedCategory,
    List<Biller> billers = const [],
    this.services = const [],
    this.selectedService,
    this.serviceFields = const [],
    this.validatedBill,
    this.scheduleDetails,
    this.saveToShortcut = false,
    this.shortcutName,
    this.returnedPayment,
  }) : _billers = billers;

  @override
  List<Object?> get props => [
        amount,
        fromAccounts,
        selectedAccount,
        actions,
        events,
        deviceUID,
        errors,
        billerCategories,
        selectedBiller,
        selectedCategory,
        _billers,
        services,
        selectedService,
        serviceFields,
        validatedBill,
        payment,
        returnedPayment,
        bill,
        scheduleDetails,
        saveToShortcut,
        shortcutName,
      ];

  /// Creates a new state based on this one.
  PayBillState copyWith({
    double? amount,
    List<Account>? fromAccounts,
    Account? selectedAccount,
    String? deviceUID,
    bool? busy,
    Set<CubitError>? errors,
    Set<PayBillBusyAction>? actions,
    List<BillerCategory>? billerCategories,
    Biller? selectedBiller,
    BillerCategory? selectedCategory,
    List<Biller>? billers,
    List<Service>? services,
    Service? selectedService,
    List<ServiceField>? serviceFields,
    Bill? validatedBill,
    ScheduleDetails? scheduleDetails,
    bool? saveToShortcut,
    String? shortcutName,
    Set<PayBillEvent>? events,
    Payment? returnedPayment,
  }) {
    return PayBillState(
      amount: amount ?? this.amount,
      fromAccounts: fromAccounts ?? this.fromAccounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      deviceUID: deviceUID ?? this.deviceUID,
      errors: errors ?? super.errors,
      events: events ?? super.events,
      actions: actions ?? super.actions,
      billerCategories: billerCategories ?? this.billerCategories,
      selectedBiller: selectedBiller ?? this.selectedBiller,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      billers: billers ?? _billers,
      returnedPayment: returnedPayment ?? this.returnedPayment,
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      serviceFields: serviceFields ?? this.serviceFields,
      validatedBill: validatedBill ?? this.validatedBill,
      scheduleDetails: scheduleDetails ?? this.scheduleDetails,
      saveToShortcut: saveToShortcut ?? this.saveToShortcut,
      shortcutName: !(saveToShortcut ?? this.saveToShortcut)
          ? null
          : (shortcutName ?? this.shortcutName),
    );
  }

  /// A list of billers that the user has to select from in order to pay.
  List<Biller> get billers {
    /// The user has to select a category in order to filter the billers.
    if (selectedCategory == null) return [];

    /// Return the billers that have the same category as
    /// the selected category.
    return _billers
        .where((element) =>
            element.category.categoryCode == selectedCategory!.categoryCode)
        .toList(growable: false);
  }

  /// The payment to be made
  Payment get payment => Payment(
        fromAccount: selectedAccount,
        bill: bill,
        amount: amount,
        currency: selectedAccount?.currency ?? '',
        deviceUID: deviceUID,
        status: PaymentStatus.completed,
        recurrence: scheduleDetails?.recurrence ?? Recurrence.none,
        scheduled: _scheduledDate,
        recurrenceStart: _recurrenceStart,
        recurrenceEnd: _recurrenceEnd,
        recurring: _recurring,
      );

  /// Wether the user can subit the form or not
  bool get canSubmit =>
      selectedAccount != null &&
      selectedCategory != null &&
      selectedBiller != null &&
      selectedService != null &&
      ((selectedAccount?.availableBalance ?? 0) >= amount) &&
      amount > 0 &&
      _serviceFieldsValid &&
      (!saveToShortcut || (shortcutName?.isNotEmpty ?? false)) &&
      (scheduleDetails?.recurrence == null ||
          scheduleDetails?.recurrence == Recurrence.none ||
          scheduleDetails?.startDate != null);

  bool get _serviceFieldsValid {
    for (var i = 0; i < serviceFields.length; i++) {
      final field = serviceFields[i];
      if (field.required && (field.value?.isEmpty ?? true)) {
        return false;
      }
    }
    return true;
  }

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

  /// The bill to be paid
  Bill get bill => Bill(
        // TODO: Change this to set nickname from app
        nickname: "${selectedBiller?.name} $deviceUID",
        service: selectedService,
        amount: amount,
        billStatus: BillStatus.active,
        billingFields: serviceFields,
        visible: false,
      );
}

/// Which loading action the cubit is doing
enum PayBillBusyAction {
  /// Loading the entire cubit state
  loading,

  /// Loading the list of services
  loadingServices,

  /// Validating user input
  validating,

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
enum PayBillEvent {
  /// Event for showing the confirmation view.
  showConfirmationView,

  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,

  /// Event for showing the payment result view.
  showResultView,
}
