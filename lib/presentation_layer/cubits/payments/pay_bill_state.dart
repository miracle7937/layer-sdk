import 'package:equatable/equatable.dart';

import '../../../domain_layer/models/account/account.dart';
import '../../../domain_layer/models/bill/bill.dart';
import '../../../domain_layer/models/payment/biller.dart';
import '../../../domain_layer/models/payment/biller_category.dart';
import '../../../domain_layer/models/payment/payment.dart';
import '../../../domain_layer/models/service/service.dart';
import '../../../domain_layer/models/service/service_field.dart';

/// Which loading action the cubit is doing
enum PayBillBusyAction {
  /// Loading the entire cubit state
  loading,

  /// Loading the list of services
  loadingServices,

  /// Submitting the payment
  submitting,

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
}

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

  /// The current error status.
  final PayBillErrorStatus errorStatus;

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

  /// Creates a new state.
  PayBillState({
    this.amount = 0,
    this.fromAccounts = const [],
    this.selectedAccount,
    this.deviceUID,
    this.busy = true,
    this.busyAction = PayBillBusyAction.loading,
    this.errorStatus = PayBillErrorStatus.none,
    this.billerCategories = const [],
    this.selectedBiller,
    this.selectedCategory,
    List<Biller> billers = const [],
    this.services = const [],
    this.selectedService,
    this.serviceFields = const [],
    this.validatedBill,
  }) : _billers = billers;

  @override
  List<Object?> get props => [
        amount,
        fromAccounts,
        selectedAccount,
        deviceUID,
        busy,
        busyAction,
        errorStatus,
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
      ];

  /// Creates a new state based on this one.
  PayBillState copyWith({
    double? amount,
    List<Account>? fromAccounts,
    Account? selectedAccount,
    String? deviceUID,
    bool? busy,
    PayBillErrorStatus? errorStatus,
    PayBillBusyAction? busyAction,
    List<BillerCategory>? billerCategories,
    Biller? selectedBiller,
    BillerCategory? selectedCategory,
    List<Biller>? billers,
    List<Service>? services,
    Service? selectedService,
    List<ServiceField>? serviceFields,
    Bill? validatedBill,
  }) {
    return PayBillState(
      amount: amount ?? this.amount,
      fromAccounts: fromAccounts ?? this.fromAccounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      deviceUID: deviceUID ?? this.deviceUID,
      busy: busy ?? this.busy,
      busyAction: busyAction ?? this.busyAction,
      errorStatus: errorStatus ?? this.errorStatus,
      billerCategories: billerCategories ?? this.billerCategories,
      selectedBiller: selectedBiller ?? this.selectedBiller,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      billers: billers ?? _billers,
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      serviceFields: serviceFields ?? this.serviceFields,
      validatedBill: validatedBill ?? this.validatedBill,
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
      amount > 0 &&
      _serviceFieldsValid;

  bool get _serviceFieldsValid {
    for (var i = 0; i < serviceFields.length; i++) {
      final field = serviceFields[i];
      if (field.required && (field.value?.isEmpty ?? true)) {
        return false;
      }
    }
    return true;
  }

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
      );
}
