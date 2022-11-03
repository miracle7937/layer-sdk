import 'package:bloc/bloc.dart';

import '../../../domain_layer/models/second_factor/second_factor_type.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for unmasking the [Card] info
class UnmaskCardInfoCubit extends Cubit<UnmaskCardInfoState> {
  final LoadCustomerCardInfoUseCase _getCustomerCardInfoUseCase;

  /// Creates a new instance of [UnmaskCardInfoCubit]
  UnmaskCardInfoCubit({
    required LoadCustomerCardInfoUseCase getCustomerCardInfoUseCase,
  })  : _getCustomerCardInfoUseCase = getCustomerCardInfoUseCase,
        super(
          UnmaskCardInfoState(),
        );

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
              ? UnmaskCardInfoAction.verifySecondFactor
              : UnmaskCardInfoAction.loadCardInfo,
        ),
        events: state.removeEvents(
          {
            UnmaskCardInfoEvent.inputSecondFactor,
          },
        ),
        otpId:
            secondFactorType != null && secondFactorType != SecondFactorType.otp
                ? null
                : state.otpId,
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
                ? UnmaskCardInfoAction.verifySecondFactor
                : UnmaskCardInfoAction.loadCardInfo,
          ),
          events: cardInfo.secondFactorType != null
              ? state.addEvent(
                  UnmaskCardInfoEvent.inputSecondFactor,
                )
              : state.addEvent(
                  UnmaskCardInfoEvent.showCardInfo,
                ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            secondFactorType != null
                ? UnmaskCardInfoAction.verifySecondFactor
                : UnmaskCardInfoAction.loadCardInfo,
          ),
          events: state.removeEvents(
            {
              UnmaskCardInfoEvent.inputSecondFactor,
            },
          ),
          errors: state.addErrorFromException(
            action: secondFactorType != null
                ? UnmaskCardInfoAction.verifySecondFactor
                : UnmaskCardInfoAction.loadCardInfo,
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
          UnmaskCardInfoAction.gettingOTPId,
        ),
        events: state.removeEvents(
          {
            UnmaskCardInfoEvent.inputSecondFactor,
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
            UnmaskCardInfoAction.gettingOTPId,
          ),
          events: state.addEvent(
            UnmaskCardInfoEvent.inputSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            UnmaskCardInfoAction.gettingOTPId,
          ),
          events: state.removeEvents(
            {
              UnmaskCardInfoEvent.inputSecondFactor,
            },
          ),
          errors: state.addErrorFromException(
            action: UnmaskCardInfoAction.gettingOTPId,
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
