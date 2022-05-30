import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// All possible errors for [CustomersState]
enum CustomersStateError {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Describe what the cubit may be busy performing.
enum CustomerBusyAction {
  /// Loading first batch of customers.
  load,

  /// Loading more customers.
  loadMore,

  /// Updating a customer grace period.
  updatingCustomerGracePeriod,

  /// Updating the customer E-Statement setting.
  updatingCustomerEStatement,
}

/// The state of the customers cubit
class CustomersState extends Equatable {
  /// A list of customers
  final UnmodifiableListView<Customer> customers;

  /// True if the cubit is processing something.
  /// This is calculated by what action is the cubit performing.
  final bool busy;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<CustomerBusyAction> actions;

  /// The current error.
  final CustomersStateError error;

  /// Has all the data needed to handle the list of customers.
  final CustomerListData listData;

  /// Creates a new [CustomersState].
  CustomersState({
    Iterable<Customer> customers = const <Customer>[],
    Set<CustomerBusyAction> actions = const <CustomerBusyAction>{},
    this.error = CustomersStateError.none,
    CustomerListData? listData,
  })  : customers = UnmodifiableListView(customers),
        actions = UnmodifiableSetView(actions),
        busy = actions.isNotEmpty,
        listData = listData ?? CustomerListData();

  @override
  List<Object?> get props => [
        customers,
        actions,
        busy,
        error,
        listData,
      ];

  /// Creates a new state based on this one.
  CustomersState copyWith({
    List<Customer>? customers,
    Set<CustomerBusyAction>? actions,
    CustomersStateError? error,
    CustomerListData? listData,
  }) =>
      CustomersState(
        customers: customers ?? this.customers,
        actions: actions ?? this.actions,
        error: error ?? this.error,
        listData: listData ?? this.listData,
      );
}

/// Keeps all the data needed for filtering the customer
class CustomerListData extends Equatable {
  /// The type of customers of this list.
  final CustomerType customerType;

  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// The current offset for the loaded list.
  final int offset;

  /// The current applied filters.
  final CustomerFilters filters;

  /// The field to use to sort the data.
  final CustomerSort sortBy;

  /// If field should be sorted in descending order.
  final bool descendingOrder;

  /// Creates a new [CustomerListData] with the default values.
  CustomerListData({
    this.customerType = CustomerType.personal,
    this.canLoadMore = false,
    this.offset = 0,
    CustomerFilters? filters,
    this.sortBy = CustomerSort.registered,
    this.descendingOrder = true,
  }) : filters = filters ?? CustomerFilters();

  @override
  List<Object?> get props => [
        customerType,
        canLoadMore,
        offset,
        filters,
        sortBy,
        descendingOrder,
      ];

  /// Creates a new object based on this one.
  CustomerListData copyWith({
    CustomerType? customerType,
    bool? canLoadMore,
    int? offset,
    CustomerFilters? filters,
    CustomerSort? sortBy,
    bool? descendingOrder,
  }) =>
      CustomerListData(
        customerType: customerType ?? this.customerType,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        offset: offset ?? this.offset,
        filters: filters ?? this.filters,
        sortBy: sortBy ?? this.sortBy,
        descendingOrder: descendingOrder ?? this.descendingOrder,
      );
}
