import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';
import 'loyalty_exchange_states.dart';

/// Cubit responsible for [LoyaltyExchange]
class LoyaltyExchangeCubit extends Cubit<LoyaltyExchangeState> {
  final LoyaltyPointsRepository _repository;
  final AccountRepository _accountRepository;
  final CardRepository _cardRepository;

  /// Creates a new cubit using the supplied [LoyaltyPointsRepository].
  LoyaltyExchangeCubit({
    required LoyaltyPointsRepository repository,
    required AccountRepository accountRepository,
    required CardRepository cardRepository,
  })  : _repository = repository,
        _accountRepository = accountRepository,
        _cardRepository = cardRepository,
        super(LoyaltyExchangeState());

  /// Load Exchange rate
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: LoyaltyExchangeErrorStatus.none,
      ),
    );

    try {
      final res = await Future.wait<dynamic>([
        _repository.getCurrentRate(),
        _accountRepository.listCustomerAccounts(
          statuses: [AccountStatus.active],
        ),
        _cardRepository.listCustomerCards(),
      ]);
      final LoyaltyRate rate = res[0];
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
              ? LoyaltyExchangeErrorStatus.network
              : LoyaltyExchangeErrorStatus.generic,
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

  /// Resets the status to [LoyaltyExchangeStatus.none]
  void resetStatus() {
    emit(
      state.copyWith(
        status: LoyaltyExchangeStatus.none,
      ),
    );
  }

  /// Do a loyalty points redemption/burn
  Future<void> post() async {
    emit(
      state.copyWith(
        processing: true,
        errorStatus: LoyaltyExchangeErrorStatus.none,
      ),
    );

    try {
      final result = await _repository.postBurn(
        amount: state.points,
        accountId: state.account?.id ?? "",
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
          status: LoyaltyExchangeStatus.error,
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
        errorStatus: LoyaltyExchangeErrorStatus.none,
      ),
    );

    try {
      final result = await _repository.postSecondFactor(
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
          status: LoyaltyExchangeStatus.error,
          transactionError: e is NetException ? e.message : e.toString(),
        ),
      );
    }
  }
}

/// Maps LoyaltyBurn to get its OTP status
extension LoyaltyBurnOTPStatus on LoyaltyExchange {
  /// Maps [LoyaltyBurn] into a [LoyaltyExchangeStatus]
  LoyaltyExchangeStatus toExchangeStatus() {
    if (status == OTPStatus.otp) {
      // Second factor is required
      switch (secondFactor) {
        case SecondFactorType.otp:
          return LoyaltyExchangeStatus.otp;

        case SecondFactorType.pin:
          return LoyaltyExchangeStatus.pin;

        case SecondFactorType.hardwareToken:
          return LoyaltyExchangeStatus.hardwareToken;

        default:
          return LoyaltyExchangeStatus.otp;
      }
    }

    // Transaction is completed
    return LoyaltyExchangeStatus.completed;
  }
}
