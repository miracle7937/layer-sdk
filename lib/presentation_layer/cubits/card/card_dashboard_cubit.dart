import 'package:bloc/bloc.dart';

import '../../../domain_layer/models/card/banking_card.dart';
import '../../../domain_layer/models/second_factor/second_factor_type.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Card]
class CardDashboardCubit extends Cubit<CardDashboardState> {
  final LoadCustomerCardsUseCase _getCustomerCardsUseCase;
  final LoadCustomerCardInfoUseCase _getCustomerCardInfoUseCase;
  final LoadFinancialDataUseCase _getFinancialDataUseCase;

  /// Creates a new instance of [CardCubit]
  CardDashboardCubit({
    required LoadCustomerCardsUseCase getCustomerCardsUseCase,
    required LoadCustomerCardInfoUseCase getCustomerCardInfoUseCase,
    required LoadFinancialDataUseCase getFinancialDataUseCase,
  })  : _getCustomerCardsUseCase = getCustomerCardsUseCase,
        _getCustomerCardInfoUseCase = getCustomerCardInfoUseCase,
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

  /// This is the second request used to get the otp ID
  Future<void> getOtpId({
    required int cardId,
    SecondFactorType? secondFactorType,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          CardDashboardAction.verifySecondFactor,
        ),
        events: state.removeEvents(
          {
            CardDashboardEvent.inputSecondFactor,
          },
        ),
        otpId: null,
        errors: {},
      ),
    );

    try {
      final cardInfo = await _getCustomerCardInfoUseCase(
        cardId: cardId,
        secondFactorType: secondFactorType,
      );

      emit(
        state.copyWith(
          otpId: cardInfo.otpId,
          actions: state.removeAction(
            CardDashboardAction.verifySecondFactor,
          ),
          events: state.addEvent(
            CardDashboardEvent.inputSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            CardDashboardAction.verifySecondFactor,
          ),
          events: state.removeEvents(
            {
              CardDashboardEvent.inputSecondFactor,
            },
          ),
          errors: state.addErrorFromException(
            action: CardDashboardAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads the card info
  Future<void> loadCardInfo({
    required int cardId,
    String? otpId,
    String? otpValue,
    String? clientResponse,
    SecondFactorType? secondFactorType,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          secondFactorType != null
              ? CardDashboardAction.verifySecondFactor
              : CardDashboardAction.loadCardInfo,
        ),
        events: state.removeEvents(
          {
            CardDashboardEvent.inputSecondFactor,
          },
        ),
        otpId: null,
        errors: {},
      ),
    );

    try {
      final cardInfo = await _getCustomerCardInfoUseCase(
        cardId: cardId,
        otpId: state.otpId,
        otpValue: otpValue,
        clientResponse: clientResponse,
        secondFactorType: secondFactorType,
      );

      emit(
        state.copyWith(
          cardInfo: cardInfo,
          otpId: null,
          actions: state.removeAction(
            secondFactorType != null
                ? CardDashboardAction.verifySecondFactor
                : CardDashboardAction.loadCardInfo,
          ),
          events: cardInfo.secondFactorType != null
              ? state.addEvent(
                  CardDashboardEvent.inputSecondFactor,
                )
              : state.addEvent(
                  CardDashboardEvent.showCardInfo,
                ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            secondFactorType != null
                ? CardDashboardAction.verifySecondFactor
                : CardDashboardAction.loadCardInfo,
          ),
          events: state.removeEvents(
            {
              CardDashboardEvent.inputSecondFactor,
            },
          ),
          errors: state.addErrorFromException(
            action: secondFactorType != null
                ? CardDashboardAction.verifySecondFactor
                : CardDashboardAction.loadCardInfo,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resets the card info saved in the state
  void removeCardInfoFromState() {
    emit(
      state.copyWith(
        cardInfo: null,
        otpId: null,
      ),
    );
  }
}
