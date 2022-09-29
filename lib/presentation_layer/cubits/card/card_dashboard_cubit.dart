import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Card]
class CardDashboardCubit extends Cubit<CardDashboardState> {
  final LoadCustomerCardsUseCase _getCustomerCardsUseCase;
  final LoadFinancialDataUseCase _getFinancialDataUseCase;

  /// Creates a new instance of [CardCubit]
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
          actions: state.addActions({
            CardDashboardAction.loadCards,
          }),
          errors: state.removeErrorForAction(CardDashboardAction.loadCards)),
    );

    try {
      final cards = await _getCustomerCardsUseCase(
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          cards: cards,
          actions: state.removeAction(CardDashboardAction.loadCards),
        ),
      );
    } on Exception catch (e) {
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
          actions: state.addActions({
            CardDashboardAction.loadFinancialData,
          }),
          errors: {}),
    );

    try {
      final financialData = await _getFinancialDataUseCase();

      emit(
        state.copyWith(
          financialData: financialData,
          actions: state.removeAction(CardDashboardAction.loadFinancialData),
        ),
      );
    } on Exception catch (e) {
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
