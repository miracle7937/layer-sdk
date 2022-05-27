import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';

import '../../cubits.dart';

/// A cubit that keeps a list of payments.
class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repository;

  /// Creates a new cubit using the supplied [PaymentRepository] and
  /// customer id.
  PaymentCubit({
    required PaymentRepository repository,
    required String customerId,
    int limit = 50,
  })  : _repository = repository,
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
      final payments = await _repository.list(
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
