import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A Cubit that handles the state for unmasking [BankingCard]s data.
class CardInfoCubit extends Cubit<CardInfoState> {
  final GetCardInfoUseCase _getCardInfoUseCase;
  final SendOTPCodeForCardInfoUseCase _sendOTPCodeForCardInfoUseCase;
  final VerifyCardInfoSecondFactorUseCase _verifyCardInfoSecondFactorUseCase;

  /// The card object.
  final BankingCard _card;

  /// Creates a new instance of [CardInfoCubit]
  CardInfoCubit({
    required GetCardInfoUseCase getCardInfoUseCase,
    required SendOTPCodeForCardInfoUseCase sendOTPCodeForCardInfoUseCase,
    required VerifyCardInfoSecondFactorUseCase
        verifyCardInfoSecondFactorUseCase,
    required BankingCard card,
  })  : _getCardInfoUseCase = getCardInfoUseCase,
        _sendOTPCodeForCardInfoUseCase = sendOTPCodeForCardInfoUseCase,
        _verifyCardInfoSecondFactorUseCase = verifyCardInfoSecondFactorUseCase,
        _card = card,
        super(
          CardInfoState(),
        );

  /// Retrieves the [CardInfo] for the [_card].
  Future<void> unmaskCardInfo() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          CardInfoAction.loadCardInfo,
        ),
        errors: state.removeErrorForAction(
          CardInfoAction.loadCardInfo,
        ),
        events: state.removeEvents(
          {
            CardInfoEvent.openSecondFactor,
            CardInfoEvent.showCardInfoView,
          },
        ),
      ),
    );

    try {
      final cardInfo = await _getCardInfoUseCase(
        card: _card,
      );

      emit(
        state.copyWith(
          cardInfo: cardInfo,
          actions: state.removeAction(
            CardInfoAction.loadCardInfo,
          ),
          events: cardInfo.secondFactorType != null
              ? state.addEvent(
                  CardInfoEvent.openSecondFactor,
                )
              : state.addEvent(
                  CardInfoEvent.showCardInfoView,
                ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            CardInfoAction.loadCardInfo,
          ),
          errors: state.addErrorFromException(
            action: CardInfoAction.loadCardInfo,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the [_card].
  Future<void> sendOTPCode() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          CardInfoAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          CardInfoAction.sendOTPCode,
        ),
        events: state.removeEvent(
          CardInfoEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final cardInfo = await _sendOTPCodeForCardInfoUseCase(
        cardId: _card.cardId,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            CardInfoAction.sendOTPCode,
          ),
          cardInfo: cardInfo,
          events: state.addEvent(
            CardInfoEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            CardInfoAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: CardInfoAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the [_card].
  Future<void> verifySecondFactor({
    String? otpCode,
    String? ocraClientResponse,
  }) async {
    assert(
      otpCode != null || ocraClientResponse != null,
      'An OTP code or OCRA client response must be provided in order for '
      'verifying the second factor',
    );

    if (otpCode == null && ocraClientResponse == null) {
      return;
    }

    emit(
      state.copyWith(
        actions: state.addAction(
          CardInfoAction.verifySecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final cardInfo = await _verifyCardInfoSecondFactorUseCase(
        card: _card,
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            CardInfoAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          cardInfo: cardInfo,
          events: state.addEvent(
            CardInfoEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            CardInfoAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: CardInfoAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Clears the card info for the [_card].
  void maskCardInfo() => emit(
        state.copyWith(
          clearCardInfo: true,
          events: {},
        ),
      );
}
