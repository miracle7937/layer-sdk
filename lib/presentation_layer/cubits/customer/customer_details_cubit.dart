import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/customer.dart';

/// Cubits that handles the [Customer] details.
class CustomerDetailsCubit extends Cubit<CustomerDetailsState> {
  final LoadCustomerByIdUseCase _loadCustomerByIdUseCase;
  final ForceCustomerUpdateUseCase _forceCustomerUpdateUseCase;
  final UpdateCustomerGracePeriodUseCase _updateCustomerGracePeriodUseCase;
  final UpdateCustomerEStatementUseCase _updateCustomerEStatmentUseCase;

  /// Creates a new [CustomerDetailsCubit] instance.
  CustomerDetailsCubit({
    required LoadCustomerByIdUseCase loadCustomerByIdUseCase,
    required ForceCustomerUpdateUseCase forceCustomerUpdateUseCase,
    required UpdateCustomerGracePeriodUseCase updateCustomerGracePeriodUseCase,
    required UpdateCustomerEStatementUseCase updateCustomerEStatementUseCase,
    Customer? customer,
  })  : _loadCustomerByIdUseCase = loadCustomerByIdUseCase,
        _forceCustomerUpdateUseCase = forceCustomerUpdateUseCase,
        _updateCustomerGracePeriodUseCase = updateCustomerGracePeriodUseCase,
        _updateCustomerEStatmentUseCase = updateCustomerEStatementUseCase,
        super(
          CustomerDetailsState(
            customer: customer,
          ),
        );

  /// Loads the customer information from the server.
  Future<void> load({
    required String customerId,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({
          CustomerDetailsAction.load,
        }),
        error: CustomerDetailsError.none,
      ),
    );

    try {
      final result = await _loadCustomerByIdUseCase(
        customerId: customerId,
        forceRefresh: true,
      );

      emit(
        state.copyWith(
          customer: result,
          actions: state.actions.difference({
            CustomerDetailsAction.load,
          }),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.load,
          }),
          error: CustomerDetailsError.loadFailed,
        ),
      );

      rethrow;
    }
  }

  /// Force updates [Customer] information
  Future<void> forceUpdate() async {
    assert(state.hasCustomer);

    emit(
      state.copyWith(
        actions: state.actions.union({
          CustomerDetailsAction.forceUpdate,
        }),
        error: CustomerDetailsError.none,
      ),
    );

    try {
      final result = await _forceCustomerUpdateUseCase(
        customerId: state.customer!.id,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.forceUpdate,
          }),
          error: result ? null : CustomerDetailsError.forceUpdateFailed,
        ),
      );

      if (result) load(customerId: state.customer!.id);
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.forceUpdate,
          }),
          error: CustomerDetailsError.forceUpdateFailed,
        ),
      );

      rethrow;
    }
  }

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  Future<void> updateCustomerGracePeriod({
    required KYCGracePeriodType type,
    int? value,
  }) async {
    assert(state.hasCustomer);

    emit(
      state.copyWith(
        actions: {
          CustomerDetailsAction.updatingCustomerGracePeriod,
        },
        error: CustomerDetailsError.none,
      ),
    );

    try {
      final result = await _updateCustomerGracePeriodUseCase(
        customerId: state.customer!.id,
        type: type,
        value: value,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.updatingCustomerGracePeriod,
          }),
          error: result
              ? null
              : CustomerDetailsError.updatingCustomerGracePeriodFailed,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.updatingCustomerGracePeriod,
          }),
          error: CustomerDetailsError.updatingCustomerGracePeriodFailed,
        ),
      );

      rethrow;
    }
  }

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  Future<void> updateCustomerEStatement({
    required bool value,
  }) async {
    assert(state.hasCustomer);

    emit(
      state.copyWith(
        actions: {
          CustomerDetailsAction.updatingCustomerEStatement,
        },
        error: CustomerDetailsError.none,
      ),
    );

    try {
      final result = await _updateCustomerEStatmentUseCase(
        customerId: state.customer!.id,
        value: value,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.updatingCustomerEStatement,
          }),
          error: result
              ? null
              : CustomerDetailsError.updatingCustomerEStatementFailed,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            CustomerDetailsAction.updatingCustomerEStatement,
          }),
          error: CustomerDetailsError.updatingCustomerEStatementFailed,
        ),
      );

      rethrow;
    }
  }
}
