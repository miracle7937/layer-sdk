import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases/card/load_customer_cards_use_case.dart';
import '../../extensions.dart';
import 'card_states.dart';

/// Cubit responsible for retrieving the list of customer [Card]
class CardCubit extends Cubit<CardState> {
  final LoadCustomerCardsUseCase _getCustomerCardsUseCase;

  /// Creates a new instance of [CardCubit]
  CardCubit({
    required LoadCustomerCardsUseCase getCustomerCardsUseCase,
    required String customerId,
  })  : _getCustomerCardsUseCase = getCustomerCardsUseCase,
        super(
          CardState(
            customerId: customerId,
          ),
        );

  /// Loads all cards of the previously provided customer id
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: CardStateErrors.none,
      ),
    );

    try {
      final cards = await _getCustomerCardsUseCase(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          cards: cards,
          busy: false,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: CardStateErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
