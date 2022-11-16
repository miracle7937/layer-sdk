import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A Cubit that handles the state for unmasking [BankingCard]s data.
class UnmaskCardInfoCubit extends Cubit<UnmaskCardInfoState> {
  final GetCardInfoUseCase _getCardInfoUseCase;
  final SendOTPCodeForCardInfoUseCase _sendOTPCodeForCardInfoUseCase;
  final VerifyCardInfoSecondFactorUseCase _verifyCardInfoSecondFactorUseCase;

  /// The card object.
  final BankingCard _card;

  /// Creates a new instance of [UnmaskCardInfoCubit]
  UnmaskCardInfoCubit({
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
          UnmaskCardInfoState(),
        );

  /// Retrieves the [CardInfo] for the passed [card].
  Future<void> getCardInfo() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          UnmaskCardInfoAction.loadCardInfo,
        ),
        errors: state.removeErrorForAction(
          UnmaskCardInfoAction.loadCardInfo,
        ),
        events: state.removeEvent(
          UnmaskCardInfoEvent.openSecondFactor,
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
            UnmaskCardInfoAction.loadCardInfo,
          ),
          events: cardInfo.secondFactorType != null
              ? state.addEvent(
                  UnmaskCardInfoEvent.openSecondFactor,
                )
              : null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            UnmaskCardInfoAction.loadCardInfo,
          ),
          errors: state.addErrorFromException(
            action: UnmaskCardInfoAction.loadCardInfo,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current [CardInfo] object in the state.
  Future<void> sendOTPCode() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          UnmaskCardInfoAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          UnmaskCardInfoAction.sendOTPCode,
        ),
        events: state.removeEvent(
          UnmaskCardInfoEvent.showOTPCodeView,
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
            UnmaskCardInfoAction.sendOTPCode,
          ),
          cardInfo: cardInfo,
          events: state.addEvent(
            UnmaskCardInfoEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            UnmaskCardInfoAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: UnmaskCardInfoAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the [CardInfo] object in the state.
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
          UnmaskCardInfoAction.verifySecondFactor,
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
            UnmaskCardInfoAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          cardInfo: cardInfo,
          events: state.addEvent(
            UnmaskCardInfoEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            UnmaskCardInfoAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: UnmaskCardInfoAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resets the card info saved in the state
  void removeCardInfoFromState() => emit(
        state.copyWith(
          cardInfo: CardInfo(),
        ),
      );
}
