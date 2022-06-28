import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../features/currency.dart';

/// The available error status
enum CurrencyErrorStatus {
  /// No errors
  none,

  /// Network error
  network,
}

///The state of the currency cubit
class CurrencyState extends Equatable {
  ///The list of [Currency] objects loaded.
  final UnmodifiableListView<Currency> currencies;

  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final CurrencyErrorStatus errorStatus;

  ///Creates a new state
  CurrencyState({
    Iterable<Currency> currencies = const <Currency>[],
    this.busy = false,
    this.errorStatus = CurrencyErrorStatus.none,
  }) : currencies = UnmodifiableListView(currencies);

  @override
  List<Object?> get props => [
        currencies,
        busy,
        errorStatus,
      ];

  ///Gets a currency from a currency code
  Currency? getCurrencyByCode({
    required String code,
  }) {
    return currencies.firstWhereOrNull(
      (currency) => currency.code == code,
    );
  }

  /// Creates a new state based on this one.
  CurrencyState copyWith({
    Iterable<Currency>? currencies,
    bool? busy,
    CurrencyErrorStatus? errorStatus,
  }) =>
      CurrencyState(
        currencies: currencies ?? this.currencies,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
