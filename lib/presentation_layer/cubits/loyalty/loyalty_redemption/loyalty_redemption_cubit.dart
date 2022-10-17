import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

/// A Cubit that handles the state for the loyalty redemption.
class LoyaltyRedemptionCubit extends Cubit<LoyaltyRedemptionState> {
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;
  final LoadCurrentLoyaltyPointsRateUseCase
      _loadCurrentLoyaltyPointsRateUseCase;
  final LoadExpiredLoyaltyPointsByDateUseCase
      _loadExpiredLoyaltyPointsByDateUseCase;
  final ExchangeLoyaltyPointsUseCase _exchangeLoyaltyPointsUseCase;
  final GetAccountsByStatusUseCase _getAccountsByStatusUseCase;
  final DateTime _expiryDate;
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

  /// Creates a new [LoyaltyRedemptionCubit].
  LoyaltyRedemptionCubit({
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadAllLoyaltyPointsUseCase loadAllLoyaltyPointsUseCase,
    required LoadCurrentLoyaltyPointsRateUseCase
        loadCurrentLoyaltyPointsRateUseCase,
    required LoadExpiredLoyaltyPointsByDateUseCase
        loadExpiredLoyaltyPointsByDateUseCase,
    required ExchangeLoyaltyPointsUseCase exchangeLoyaltyPointsUseCase,
    required GetAccountsByStatusUseCase getAccountsByStatusUseCase,
    required DateTime expiryDate,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
  })  : _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadAllLoyaltyPointsUseCase = loadAllLoyaltyPointsUseCase,
        _loadCurrentLoyaltyPointsRateUseCase =
            loadCurrentLoyaltyPointsRateUseCase,
        _loadExpiredLoyaltyPointsByDateUseCase =
            loadExpiredLoyaltyPointsByDateUseCase,
        _expiryDate = expiryDate,
        _exchangeLoyaltyPointsUseCase = exchangeLoyaltyPointsUseCase,
        _getAccountsByStatusUseCase = getAccountsByStatusUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        super(LoyaltyRedemptionState());

  /// Initializes the [LoyaltyRedemptionCubit].
  Future<void> initialize() async {
    await Future.wait([
      _loadCurrencies(),
      _loadAccounts(),
      _loadLoyaltyPointsRate(),
      _loadLoyaltyPoints(),
      _loadLoyaltyPointsExpiration(),
      _loadBaseCurrency(),
    ]);
  }

  /// Loads all currencies.
  Future<void> _loadCurrencies() async {
    if (state.currencies.isEmpty ||
        state.errors.contains(LoyaltyRedemptionAction.currencies)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            LoyaltyRedemptionAction.currencies,
          ),
          errors: state.removeErrorForAction(
            LoyaltyRedemptionAction.currencies,
          ),
        ),
      );

      try {
        final currencies = await _loadAllCurrenciesUseCase();

        emit(
          state.copyWith(
            actions: state.removeAction(
              LoyaltyRedemptionAction.currencies,
            ),
            currencies: currencies,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              LoyaltyRedemptionAction.currencies,
            ),
            errors: state.addErrorFromException(
              action: LoyaltyRedemptionAction.currencies,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Loads all accounts.
  Future<void> _loadAccounts() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(LoyaltyRedemptionAction.accounts)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            LoyaltyRedemptionAction.accounts,
          ),
          errors: state.removeErrorForAction(
            LoyaltyRedemptionAction.accounts,
          ),
        ),
      );

      try {
        final accounts = await _getAccountsByStatusUseCase(
          statuses: [AccountStatus.active],
        );

        emit(
          state.copyWith(
            actions: state.removeAction(
              LoyaltyRedemptionAction.accounts,
            ),
            accounts: accounts,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              LoyaltyRedemptionAction.accounts,
            ),
            errors: state.addErrorFromException(
              action: LoyaltyRedemptionAction.accounts,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Loads loyalty points rate.
  Future<void> _loadLoyaltyPointsRate() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyRedemptionAction.rate,
        ),
        errors: state.removeErrorForAction(
          LoyaltyRedemptionAction.rate,
        ),
      ),
    );

    try {
      final rate = await _loadCurrentLoyaltyPointsRateUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.rate,
          ),
          loyaltyPoints: state.loyaltyPoints.copyWith(
            rate: rate.rate.toDouble(),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.rate,
          ),
          errors: state.addErrorFromException(
            action: LoyaltyRedemptionAction.rate,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads loyalty points.
  Future<void> _loadLoyaltyPoints() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyRedemptionAction.points,
        ),
        errors: state.removeErrorForAction(
          LoyaltyRedemptionAction.points,
        ),
      ),
    );

    try {
      final loyaltyPoints = await _loadAllLoyaltyPointsUseCase();

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.points,
          ),
          loyaltyPoints: loyaltyPoints.isEmpty
              ? null
              : loyaltyPoints.first.copyWith(
                  rate: state.loyaltyPoints.rate,
                  dueExpiryPoints: state.loyaltyPoints.dueExpiryPoints,
                ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.points,
          ),
          errors: state.addErrorFromException(
            action: LoyaltyRedemptionAction.points,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads loyalty expiration points.
  Future<void> _loadLoyaltyPointsExpiration() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyRedemptionAction.expiredPoints,
        ),
        errors: state.removeErrorForAction(
          LoyaltyRedemptionAction.expiredPoints,
        ),
      ),
    );

    try {
      final dueExpiryPoints = await _loadExpiredLoyaltyPointsByDateUseCase(
        expirationDate: _expiryDate,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.expiredPoints,
          ),
          loyaltyPoints: state.loyaltyPoints.copyWith(
            dueExpiryPoints: dueExpiryPoints.amount,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.expiredPoints,
          ),
          errors: state.addErrorFromException(
            action: LoyaltyRedemptionAction.expiredPoints,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads base currency.
  Future<void> _loadBaseCurrency() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyRedemptionAction.baseCurrency,
        ),
        errors: state.removeErrorForAction(
          LoyaltyRedemptionAction.baseCurrency,
        ),
      ),
    );

    try {
      final baseCurrencySettings = await _loadGlobalSettingsUseCase(
        codes: ['base_currency'],
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.baseCurrency,
          ),
          baseCurrencyCode: baseCurrencySettings.isEmpty
              ? null
              : baseCurrencySettings.first.value,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.baseCurrency,
          ),
          errors: state.addErrorFromException(
            action: LoyaltyRedemptionAction.baseCurrency,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Do a loyalty points redemption
  Future<void> exchange() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          LoyaltyRedemptionAction.exchange,
        ),
        errors: state.removeErrorForAction(
          LoyaltyRedemptionAction.exchange,
        ),
      ),
    );

    try {
      final exchangeResult = await _exchangeLoyaltyPointsUseCase(
        amount: state.loyaltyPoints.balance,
        accountId: state.accounts.first.id ?? '',
      );
      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.exchange,
          ),
          exchangeResult: exchangeResult,
          events: state.addEvent(
            LoyaltyRedemptionEvent.showResultView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            LoyaltyRedemptionAction.exchange,
          ),
          errors: state.addErrorFromException(
            action: LoyaltyRedemptionAction.exchange,
            exception: e,
          ),
        ),
      );
    }
  }
}
