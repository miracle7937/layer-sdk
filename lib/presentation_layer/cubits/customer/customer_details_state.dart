import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../features/customer.dart';

/// Represents all available actions for the [CustomerDetailsCubit].
enum CustomerDetailsAction {
  /// No actions
  none,

  /// Loading the [Customer] data.
  load,

  /// Forcing customer update.
  forceUpdate,

  /// Updating a customer grace period.
  updatingCustomerGracePeriod,

  /// Updating the customer E-Statement setting.
  updatingCustomerEStatement,
}

/// All possible errors for [CustomerDetailsCubit]
enum CustomerDetailsError {
  /// No error
  none,

  /// Failed to load the [Customer] data.
  loadFailed,

  /// Could not load force update the [Customer]. data.
  forceUpdateFailed,

  /// Could not update [Customer] grace period information.
  updatingCustomerGracePeriodFailed,

  /// Could not update the [Customer] E-Statement setting.
  updatingCustomerEStatementFailed,
}

/// Holds the [CustomerDetailsCubit] state.
class CustomerDetailsState extends Equatable {
  /// The [Customer] being handled by the cubit.
  final Customer? customer;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<CustomerDetailsAction> actions;

  /// The current error.
  final CustomerDetailsError error;

  /// Helper getter that checks if the customer is != null.
  bool get hasCustomer => customer != null;

  /// Creates a new [CustomerDetailsState] instance.
  CustomerDetailsState({
    this.customer,
    this.error = CustomerDetailsError.none,
    Set<CustomerDetailsAction> actions = const <CustomerDetailsAction>{},
  }) : actions = UnmodifiableSetView(actions);

  /// Creates a new [CustomerDetailsState] with the provided parameters.
  CustomerDetailsState copyWith({
    Customer? customer,
    CustomerDetailsError? error,
    Set<CustomerDetailsAction>? actions,
  }) {
    return CustomerDetailsState(
      customer: customer ?? this.customer,
      error: error ?? this.error,
      actions: actions ?? this.actions,
    );
  }

  @override
  List<Object?> get props => [
        customer,
        error,
        actions,
      ];
}
