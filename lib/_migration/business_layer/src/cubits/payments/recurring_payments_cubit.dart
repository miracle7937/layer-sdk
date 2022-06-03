import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import '../../cubits.dart';

/// A cubit that keeps a list of recurring payments.
class RecurringPaymentCubit extends Cubit<RecurringPaymentState> {
  final PaymentRepository _repository;

  /// Creates a new cubit using the supplied [PaymentRepository] and
  /// customer id.
  RecurringPaymentCubit({
    required PaymentRepository repository,
    required String customerId,
    int limit = 50,
  })  : _repository = repository,
        super(
          RecurringPaymentState(
            customerId: customerId,
            limit: limit,
          ),
        );

  /// Loads the customer's list of recurring payments
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        customerId: state.customerId,
        busy: true,
        errorStatus: RecurringPaymentErrorStatus.none,
      ),
    );

    final offset = loadMore ? state.offset + state.limit : 0;

    try {
      final recurringPayments = await _repository.list(
        customerId: state.customerId,
        offset: offset,
        limit: state.limit,
        forceRefresh: forceRefresh,
        recurring: true,
      );

      final list = offset > 0
          ? [
              ...state.recurringPayments.take(offset).toList(),
              ...recurringPayments
            ]
          : recurringPayments;

      emit(
        state.copyWith(
          customerId: state.customerId,
          recurringPayments: list,
          busy: false,
          offset: offset,
          canLoadMore: state.recurringPayments.length != list.length,
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          customerId: state.customerId,
          busy: false,
          errorStatus: RecurringPaymentErrorStatus.network,
        ),
      );
    }
  }
}
