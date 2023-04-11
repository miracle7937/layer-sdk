import 'package:bloc/bloc.dart';

import '../../../domain_layer/models/card/banking_card.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// Cubit responsible for retrieving the list of customer [Card]
class CardDashboardCubit extends Cubit<CardDashboardState> {
  final LoadCustomerCardsUseCase _getCustomerCardsUseCase;
  final LoadFinancialDataUseCase _getFinancialDataUseCase;

  /// Creates a new instance of [CardDashboardCubit]
  CardDashboardCubit({
    required LoadCustomerCardsUseCase getCustomerCardsUseCase,
    required LoadFinancialDataUseCase getFinancialDataUseCase,
  })  : _getCustomerCardsUseCase = getCustomerCardsUseCase,
        _getFinancialDataUseCase = getFinancialDataUseCase,
        super(
          CardDashboardState(),
        );

  /// Loads all cards and financial data
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    await Future.wait([
      loadCards(forceRefresh: forceRefresh),
      loadFinancialData(forceRefresh: forceRefresh),
    ]);
  }

  /// Loads all cards
  Future<void> loadCards({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(CardDashboardAction.loadCards),
        errors: {},
      ),
    );

    try {
      var cards = await _getCustomerCardsUseCase(
        forceRefresh: forceRefresh,
      );

      cards = List.from(cards)
        ..retainWhere((card) {
          if (card.status == CardStatus.closed) {
            return false;
          } else {
            return true;
          }
        });

      emit(
        state.copyWith(
          cards: cards,
          actions: state.removeAction(CardDashboardAction.loadCards),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(CardDashboardAction.loadCards),
          errors: state.addErrorFromException(
            action: CardDashboardAction.loadCards,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads financial data
  Future<void> loadFinancialData({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(CardDashboardAction.loadFinancialData),
        errors: {},
      ),
    );

    try {
      final financialData = await _getFinancialDataUseCase();

      emit(
        state.copyWith(
          financialData: financialData,
          actions: state.removeAction(CardDashboardAction.loadFinancialData),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(CardDashboardAction.loadFinancialData),
          errors: state.addErrorFromException(
            action: CardDashboardAction.loadFinancialData,
            exception: e,
          ),
        ),
      );
    }
  }
}
