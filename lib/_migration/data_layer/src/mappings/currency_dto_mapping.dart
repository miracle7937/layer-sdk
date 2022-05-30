import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mapping for [CurrencyDTO]
extension CurrencyDTOMapping on CurrencyDTO {
  /// Maps a [CurrencyDTO] instance to a [Currency] model
  Currency toCurrency() => Currency(
        code: code,
        name: name,
        symbol: symbol,
        trfIntl: trfIntl,
        visible: visible,
        created: created,
        updated: updated,
        decimals: decimals,
        rate: rate,
        buy: buy,
        sell: sell,
        numericCode: numericCode,
      );
}
