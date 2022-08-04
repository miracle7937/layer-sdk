import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../features/currency.dart';

/// A cubit that keeps currencies
class CurrencyCubit extends Cubit<CurrencyState> {
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadCurrencyByCodeUseCase _loadCurrencyByCodeUseCase;

  /// Creates a new cubit using the supplied use cases.
  CurrencyCubit({
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadCurrencyByCodeUseCase loadCurrencyByCodeUseCase,
  })  : _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadCurrencyByCodeUseCase = loadCurrencyByCodeUseCase,
        super(CurrencyState());

  /// Gets the list of currencies.
  ///
  /// If [code] is supplied, it will only refresh that country code.
  /// (if the currencies list is empty, will return the country with that code,
  /// if it's not empty, will update only the country that has the code).
  Future<void> load({
    String? code,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: CurrencyErrorStatus.none,
      ),
    );

    try {
      List<Currency> currencies;

      if (code != null) {
        final currency = await _loadCurrencyByCodeUseCase(
          code: code,
          forceRefresh: forceRefresh,
          // TODO: when merging akorn-staging:
          // TODO: check how to handle the `onlyVisible` here not to break DBO
        );

        currencies = [
          ...state.currencies.where((element) => element.code != code),
          if (currency != null) currency,
        ];
      } else {
        currencies = await _loadAllCurrenciesUseCase(
          forceRefresh: forceRefresh,
        );
      }

      emit(
        state.copyWith(
          currencies: currencies,
          busy: false,
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: CurrencyErrorStatus.network,
        ),
      );

      rethrow;
    }
  }

  /// Updates the list of [Currency] in the state
  Future<void> update({
    required Iterable<Currency> currencies,
  }) async {
    emit(
      state.copyWith(
        currencies: currencies,
      ),
    );
  }
}
