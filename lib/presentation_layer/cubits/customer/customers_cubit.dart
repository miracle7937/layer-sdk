import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../data_layer/repositories.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps the list of customers.
class CustomersCubit extends Cubit<CustomersState> {
  final LoadCustomerUseCase _getCustomerUseCase;

  /// Maximum number of customers to load at a time.
  final int limit;

  /// Allows the cancellation of previous list requests.
  final listCanceller = NetRequestCanceller();

  /// Creates a new cubit using the supplied [CustomerRepository].
  CustomersCubit({
    required LoadCustomerUseCase getCustomerUseCase,
    CustomerType customerType = CustomerType.personal,
    this.limit = 50,
  })  : _getCustomerUseCase = getCustomerUseCase,
        super(
          CustomersState(
            listData: CustomerListData(
              customerType: customerType,
            ),
          ),
        );

  @override
  Future<void> close() {
    listCanceller.dispose();

    return super.close();
  }

  /// Resets the cubit to an empty state.
  ///
  /// The optional [customerType] can be used to reset to a specific type.
  void reset({
    CustomerType? customerType,
  }) =>
      emit(
        CustomersState(
          listData: customerType != null
              ? CustomerListData(customerType: customerType)
              : null,
        ),
      );

  /// Loads a sorted list of customers, optionally filtering by several fields.
  ///
  /// If [loadMore] is true, will try to update the list with more data.
  ///
  /// If [customerType] is null, will reuse the last customerType.
  ///
  /// If [filters] is null, will reuse the last used filters.
  Future<void> load({
    CustomerType? customerType,
    CustomerFilters? filters,
    bool loadMore = false,
    bool forceRefresh = false,
    CustomerSort sortBy = CustomerSort.registered,
    bool descendingOrder = true,
  }) async {
    final previousType = state.listData.customerType;
    final effectiveType = customerType ?? state.listData.customerType;
    final effectiveFilters = filters ?? state.listData.filters;

    try {
      await listCanceller.reset();

      final isLoadingMore = loadMore &&
          effectiveType == state.listData.customerType &&
          effectiveFilters == state.listData.filters &&
          sortBy == state.listData.sortBy &&
          descendingOrder == state.listData.descendingOrder;

      emit(
        state.copyWith(
          actions: state.actions.union({
            isLoadingMore
                ? CustomerBusyAction.loadMore
                : CustomerBusyAction.load,
          }),
          listData: state.listData.copyWith(
            customerType: effectiveType,
          ),
          error: CustomersStateError.none,
        ),
      );

      final offset = isLoadingMore ? state.listData.offset + limit : 0;

      final customers = await _getCustomerUseCase(
        customerType: effectiveType,
        filters: effectiveFilters,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
        offset: offset,
        limit: limit,
        forceRefresh: forceRefresh,
        requestCanceller: listCanceller,
      );

      final list = offset > 0
          ? [
              ...state.customers.take(offset).toList(),
              ...customers,
            ]
          : customers;

      emit(
        state.copyWith(
          customers: list,
          actions: state.actions.difference({
            CustomerBusyAction.load,
            CustomerBusyAction.loadMore,
          }),
          listData: state.listData.copyWith(
            canLoadMore: customers.length >= limit,
            filters: effectiveFilters,
            offset: offset,
            sortBy: sortBy,
            descendingOrder: descendingOrder,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerBusyAction.load,
            CustomerBusyAction.loadMore,
          }),
          listData: state.listData.copyWith(
            customerType: previousType,
          ),
          error: CustomersStateError.generic,
        ),
      );

      rethrow;
    }
  }
}
