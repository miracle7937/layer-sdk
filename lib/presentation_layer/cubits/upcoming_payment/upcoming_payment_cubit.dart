import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps upcoming payments
class UpcomingPaymentCubit extends Cubit<UpcomingPaymentState> {
  final LoadUpcomingPaymentsUseCase _loadUpcomingPaymentsUseCase;

  /// Creates a new cubit using the supplied use cases.
  UpcomingPaymentCubit({
    required LoadUpcomingPaymentsUseCase loadUpcomingPaymentsUseCase,
    int limit = 50,
  })  : _loadUpcomingPaymentsUseCase = loadUpcomingPaymentsUseCase,
        super(
          UpcomingPaymentState(
            pagination: Pagination(limit: limit),
          ),
        );

  /// Loads the upcoming payments
  ///
  /// When indicating the cardId it only will return the upcoming payments
  /// for that card
  Future<void> load({
    String? cardId,
    UpcomingPaymentType? type,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    );

    try {
      final upcomingPayments = await _loadUpcomingPaymentsUseCase(
        cardId: cardId,
        type: type,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          upcomingPayments: upcomingPayments,
          total: upcomingPayments.fold(
            0.0,
            (amount, payment) => (amount ?? 0.0) + (payment.amount ?? 0.0),
          ),
          currency: upcomingPayments.isNotEmpty
              ? upcomingPayments.first.currency
              : '',
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? UpcomingPaymentErrorStatus.network
              : UpcomingPaymentErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
