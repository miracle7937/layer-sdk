import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps a list of payments.
class PaymentCubit extends Cubit<PaymentState> {
  final LoadCustomerPaymentsUseCase _loadCustomerPaymentsUseCase;

  /// Creates a new cubit using the supplied [LoadCustomerPaymentsUseCase] and
  /// customer id.
  PaymentCubit({
    required LoadCustomerPaymentsUseCase loadCustomerPaymentsUseCase,
    required String customerId,
    int limit = 50,
  })  : _loadCustomerPaymentsUseCase = loadCustomerPaymentsUseCase,
        super(
          PaymentState(
            customerId: customerId,
            limit: limit,
          ),
        );

  /// Loads the customer's list of payments
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        customerId: state.customerId,
        busy: true,
        errorStatus: PaymentErrorStatus.none,
      ),
    );

    final offset = loadMore ? state.offset + state.limit : 0;

    try {
      final payments = await _loadCustomerPaymentsUseCase(
        customerId: state.customerId,
        offset: offset,
        limit: state.limit,
        forceRefresh: forceRefresh,
        recurring: false,
      );

      final list = offset > 0
          ? [...state.payments.take(offset).toList(), ...payments]
          : payments;

      emit(
        state.copyWith(
          customerId: state.customerId,
          payments: list,
          busy: false,
          offset: offset,
          canLoadMore: state.payments.length != list.length,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          customerId: state.customerId,
          busy: false,
          errorStatus: e is NetException
              ? PaymentErrorStatus.network
              : PaymentErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
