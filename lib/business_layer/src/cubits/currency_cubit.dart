import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../../data_layer/data_layer.dart';
import '../../../migration/data_layer/network.dart';
import 'currency_state.dart';

/// A cubit that keeps currencies
class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _repository;

  /// Creates a new cubit using the supplied [CurrencyRepository]
  CurrencyCubit({
    required CurrencyRepository repository,
  })  : _repository = repository,
        super(
          CurrencyState(),
        );

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
        final currency = await _repository.getCurrencyByCode(
          code: code,
          forceRefresh: forceRefresh,
        );

        currencies = [
          ...state.currencies.where((element) => element.code != code),
          if (currency != null) currency,
        ];
      } else {
        currencies = await _repository.list(
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

  /// Formats the provided [value] as a currency String.
  ///
  /// Returns `null` when [value] is null.
  ///
  /// If not null, the [value] will be formatted following the following
  /// properties:
  ///
  /// If [withSymbol] is `true`, will include the currency symbol, as long
  /// as the other properties allow.
  ///
  /// If [currencyCode] is provided, will look for the currency (case
  /// insensitive) on the loaded currency list, and if found use its symbol and
  /// decimals. If the currency is not found, returns `null`.
  ///
  /// The number of decimals digits to used can be passed on [decimals]. If not
  /// provided, the method will try to use the number of decimal digits from
  /// the currency found through [currencyCode]. If not found, the method will
  /// use the default decimal digits from the locale.
  ///
  /// If [locale] is not provided, it will use the current default locale. This
  /// string is case-insensitive.
  ///
  /// The [customPattern] parameter can be used to specify a particular
  /// format. This is useful if you have your own locale data which includes
  /// unsupported formats (e.g. accounting format for currencies.)
  ///
  /// An example of [customPattern] would be '\u00a4 #,###.#;\u00a4 -#,###.#' to
  /// have two formats: the first for positive values, and the second for
  /// negative ones. The positive would present like `USD 1,23,45.00`.
  ///
  /// For more information on custom pattern, please look at:
  /// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
  String? formatCurrency({
    num? value,
    bool withSymbol = true,
    String? currencyCode,
    int? decimals,
    String? locale,
    String? customPattern,
  }) {
    if (value == null) return null;

    final currency = currencyCode != null
        ? state.currencies.firstWhereOrNull(
            (x) => x.code?.toLowerCase() == currencyCode.toLowerCase(),
          )
        : null;

    if (currency == null && (currencyCode?.isNotEmpty ?? false)) {
      return null;
    }

    return NumberFormat.currency(
      symbol: withSymbol ? currency?.symbol : '',
      decimalDigits: decimals ?? currency?.decimals,
      locale: locale,
      customPattern: customPattern,
    ).format(value).trim();
  }
}
