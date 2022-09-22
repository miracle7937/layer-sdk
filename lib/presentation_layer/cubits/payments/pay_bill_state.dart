import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The state of the bill payment cubit
class PayBillState extends Equatable {
  /// The amount to be paid
  final double amount;

  /// A list of accounts that the user has to select from in order to pay.
  final List<Account> fromAccounts;

  /// The account that the user selected to pay from.
  final Account? selectedAccount;

  /// A unique identifier of the payment.
  final String? deviceUID;

  /// True if the cubit is processing something.
  final bool busy;

  /// Which busy action is the cubit doing
  final PayBillBusyAction busyAction;

  /// The errors.
  final UnmodifiableSetView<PayBillError> errors;

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

  /// Creates a new state.
  PayBillState({
    this.amount = 0,
    this.fromAccounts = const [],
    this.selectedAccount,
    this.deviceUID,
    this.busy = true,
    this.busyAction = PayBillBusyAction.loading,
    Set<PayBillError> errors = const <PayBillError>{},
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
  })  : errors = UnmodifiableSetView(errors),
        _billers = billers;

  @override
  List<Object?> get props => [
        amount,
        fromAccounts,
        selectedAccount,
        deviceUID,
        busy,
        busyAction,
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
    Set<PayBillError>? errors,
    PayBillBusyAction? busyAction,
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
  }) {
    return PayBillState(
      amount: amount ?? this.amount,
      fromAccounts: fromAccounts ?? this.fromAccounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      deviceUID: deviceUID ?? this.deviceUID,
      busy: busy ?? this.busy,
      busyAction: busyAction ?? this.busyAction,
      errors: errors ?? this.errors,
      billerCategories: billerCategories ?? this.billerCategories,
      selectedBiller: selectedBiller ?? this.selectedBiller,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      billers: billers ?? _billers,
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

  /// Wether the user can subit the form or not
  bool get canSubmit =>
      !busy &&
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
}

/// Model used for the errors.
class PayBillError extends Equatable {
  /// The action.
  final PayBillBusyAction action;

  /// The error.
  final PayBillErrorStatus errorStatus;

  /// The error code.
  final String? code;

  /// The error message.
  final String? message;

  /// Creates a new [PayBillError].
  const PayBillError({
    required this.action,
    required this.errorStatus,
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [
        action,
        errorStatus,
        code,
        message,
      ];
}

/// Which loading action the cubit is doing
enum PayBillBusyAction {
  /// No errors
  none,

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
enum PayBillErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,

  /// Incorrect OTP code.
  incorrectOTPCode,
}