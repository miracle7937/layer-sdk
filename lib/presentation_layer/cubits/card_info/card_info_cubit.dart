import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A Cubit that handles the state for unmasking [BankingCard]s data.
class CardInfoCubit extends Cubit<CardInfoState> {
  final GetCardInfoUseCase _getCardInfoUseCase;
  final SendOTPCodeForCardInfoUseCase _sendOTPCodeForCardInfoUseCase;
  final VerifyCardInfoSecondFactorUseCase _verifyCardInfoSecondFactorUseCase;

  /// The card object.
  final BankingCard _card;

  /// If `true`, the card info will be loaded from BE and from the SDK that
  /// we use for unmasking the card details.
  /// (Card number and cvv. Currently we use Meawallet).
  ///
  /// If `false`, it will only load the card info from BE.
  /// (Won't unmaks the card number and cvv).
  ///
  /// Default is `true`.
  final bool _shouldUnmaskCard;

  /// Creates a new instance of [CardInfoCubit]
  CardInfoCubit({
    required GetCardInfoUseCase getCardInfoUseCase,
    required SendOTPCodeForCardInfoUseCase sendOTPCodeForCardInfoUseCase,
    required VerifyCardInfoSecondFactorUseCase
        verifyCardInfoSecondFactorUseCase,
    required BankingCard card,
    bool shouldUnmaskCard = true,
  })  : _getCardInfoUseCase = getCardInfoUseCase,
        _sendOTPCodeForCardInfoUseCase = sendOTPCodeForCardInfoUseCase,
        _verifyCardInfoSecondFactorUseCase = verifyCardInfoSecondFactorUseCase,
        _card = card,
        _shouldUnmaskCard = shouldUnmaskCard,
        super(CardInfoState());

  /// Retrieves the [CardInfo] for the [_card].
  Future<void> loadCardInfo() async {
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
        shouldUnmaskCard: _shouldUnmaskCard,
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
    } on Exception catch (e, st) {
      logException(e, st);
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
    } on Exception catch (e, st) {
      logException(e, st);
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
    try {
      assert(
        otpCode != null || ocraClientResponse != null,
        'An OTP code or OCRA client response must be provided in order for '
        'verifying the second factor',
      );

      if (otpCode == null && ocraClientResponse == null) {
        return;
      }

      assert(
        otpCode == null || state.cardInfo?.otpId != null,
        'Verifying the OTP but the otpId on the card info is null',
      );

      if (otpCode != null && state.cardInfo?.otpId == null) {
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

      final cardInfo = await _verifyCardInfoSecondFactorUseCase(
        card: _card,
        shouldUnmaskCard: _shouldUnmaskCard,
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
        otpId: otpCode != null ? state.cardInfo!.otpId! : null,
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
    } on Exception catch (e, st) {
      logException(e, st);
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
  void hideCardInfo() => emit(
        state.copyWith(
          clearCardInfo: true,
          events: {},
        ),
      );
}
