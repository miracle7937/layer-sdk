import 'package:bloc/bloc.dart';

import '../../../../_migration/data_layer/data_layer.dart';
import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

/// Cubit responsible for [LoyaltyPointsExchange]
/// TODO: Change the accounts to use the new structure.
/// TODO: Change the cards to use the new strucutre.
class LoyaltyPointsExchangeCubit extends Cubit<LoyaltyPointsExchangeState> {
  final LoadCurrentLoyaltyPointsRateUseCase
      _loadCurrentLoyaltyPointsRateUseCase;
  final ExchangeLoyaltyPointsUseCase _exchangeLoyaltyPointsUseCase;
  final ConfirmSecondFactorForLoyaltyPointsExchangeUseCase
      _confirmSecondFactorForLoyaltyPointsExchangeUseCase;
  final GetAccountsByStatusUseCase _getAccountsByStatusUseCase;
  final CardRepository _cardRepository;

  /// Creates a new [LoyaltyPointsExchangeCubit] using the supplied use cases.
  LoyaltyPointsExchangeCubit({
    required LoadCurrentLoyaltyPointsRateUseCase
        loadCurrentLoyaltyPointsRateUseCase,
    required ExchangeLoyaltyPointsUseCase exchangeLoyaltyPointsUseCase,
    required ConfirmSecondFactorForLoyaltyPointsExchangeUseCase
        confirmSecondFactorForLoyaltyPointsExchangeUseCase,
    required GetAccountsByStatusUseCase getAccountsByStatusUseCase,
    required CardRepository cardRepository,
  })  : _loadCurrentLoyaltyPointsRateUseCase =
            loadCurrentLoyaltyPointsRateUseCase,
        _exchangeLoyaltyPointsUseCase = exchangeLoyaltyPointsUseCase,
        _confirmSecondFactorForLoyaltyPointsExchangeUseCase =
            confirmSecondFactorForLoyaltyPointsExchangeUseCase,
        _getAccountsByStatusUseCase = getAccountsByStatusUseCase,
        _cardRepository = cardRepository,
        super(LoyaltyPointsExchangeState());

  /// Load Exchange rate
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: LoyaltyPointsExchangeErrorStatus.none,
      ),
    );

    try {
      final res = await Future.wait<dynamic>([
        _loadCurrentLoyaltyPointsRateUseCase(),
        _getAccountsByStatusUseCase(
          statuses: [AccountStatus.active],
        ),
        _cardRepository.listCustomerCards(),
      ]);
      final LoyaltyPointsRate rate = res[0];
      final List<Account> accounts = res[1];
      final cards = (res[2] as List<BankingCard>)
          .where((element) => element.status == CardStatus.active)
          .toList();

      emit(
        state.copyWith(
          busy: false,
          rate: rate.rate,
          accounts: accounts,
          cards: cards,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? LoyaltyPointsExchangeErrorStatus.network
              : LoyaltyPointsExchangeErrorStatus.generic,
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Set the amount of points to be exchanged
  void setPoints(int points) {
    emit(
      state.copyWith(
        points: points,
      ),
    );
  }

  /// Set the account that will receive the points exchanged
  void setAccount(Account account) {
    emit(
      state.copyWith(
        account: account,
        card: null,
      ),
    );
  }

  /// Set the card that will receive the points exchanges
  void setCard(BankingCard card) {
    emit(
      state.copyWith(
        card: card,
        account: null,
      ),
    );
  }

  /// Resets the status to [LoyaltyPointsExchangeStatus.none]
  void resetStatus() {
    emit(
      state.copyWith(
        status: LoyaltyPointsExchangeStatus.none,
      ),
    );
  }

  /// Do a loyalty points redemption/burn
  Future<void> post() async {
    emit(
      state.copyWith(
        processing: true,
        errorStatus: LoyaltyPointsExchangeErrorStatus.none,
      ),
    );

    try {
      final result = await _exchangeLoyaltyPointsUseCase(
        amount: state.points,
        //accountId: state.account?.id ?? "",
      );
      emit(
        state.copyWith(
          processing: false,
          loyaltyExchange: result,
          status: result.toExchangeStatus(),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          processing: false,
          status: LoyaltyPointsExchangeStatus.error,
          transactionError: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Sends a new request for handling second factor
  Future<void> postSecondFactor({
    String? pin,
    String? hardwareToken,
    String? otp,
  }) async {
    emit(
      state.copyWith(
        processing: true,
        errorStatus: LoyaltyPointsExchangeErrorStatus.none,
      ),
    );

    try {
      final result = await _confirmSecondFactorForLoyaltyPointsExchangeUseCase(
        transactionId: state.loyaltyExchange.transactionId!,
        hardwareToken: hardwareToken,
        pin: pin,
        otp: otp,
        otpId: state.loyaltyExchange.otpId,
      );

      emit(
        state.copyWith(
          processing: false,
          loyaltyExchange: result,
          status: result.toExchangeStatus(),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          processing: false,
          status: LoyaltyPointsExchangeStatus.error,
          transactionError: e is NetException ? e.message : e.toString(),
        ),
      );
    }
  }
}

/// Maps LoyaltyBurn to get its OTP status
extension LoyaltyBurnOTPStatus on LoyaltyPointsExchange {
  /// Maps [OTPStatus] into a [LoyaltyPointsExchangeStatus]
  LoyaltyPointsExchangeStatus toExchangeStatus() {
    if (status == OTPStatus.otp) {
      // Second factor is required
      switch (secondFactor) {
        case SecondFactorType.otp:
          return LoyaltyPointsExchangeStatus.otp;

        case SecondFactorType.pin:
          return LoyaltyPointsExchangeStatus.pin;

        case SecondFactorType.hardwareToken:
          return LoyaltyPointsExchangeStatus.hardwareToken;

        default:
          return LoyaltyPointsExchangeStatus.otp;
      }
    }

    // Transaction is completed
    return LoyaltyPointsExchangeStatus.completed;
  }
}
