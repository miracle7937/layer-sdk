import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'card_states.dart';

/// Cubit responsible for retrieving the list of customer [Card]
class CardCubit extends Cubit<CardState> {
  final CardRepository _repository;

  /// Creates a new instance of [CardCubit]
  CardCubit({
    required CardRepository repository,
    required String customerId,
  })  : _repository = repository,
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
      final cards = await _repository.listCustomerCards(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          cards: cards,
          busy: false,
        ),
      );
    } on Exception {
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
