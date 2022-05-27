import '../helpers.dart';

///Data transfer object representing the currencies
class CurrencyDTO {
  ///The code that identifies the currency
  String? code;

  ///The name of the currency
  String? name;

  ///The currency symbol
  String? symbol;

  ///Whether the currency is valid for international transfers
  bool? trfIntl;

  ///Whether the currency is visible or not
  bool? visible;

  ///Date the currency was created
  DateTime? created;

  ///Last time the currency was updated
  DateTime? updated;

  ///The amount of decimals for the currency
  int? decimals;

  ///The rate for the currency
  double? rate;

  ///The amount the currency is buyed for
  double? buy;

  ///The amount the currency is selled for
  double? sell;

  ///A code that identifies the currency
  String? numericCode;

  ///Creates a new [CurrencyDTO] object
  CurrencyDTO({
    this.code,
    this.name,
    this.symbol,
    this.trfIntl,
    this.visible,
    this.created,
    this.updated,
    this.decimals,
    this.rate,
    this.buy,
    this.sell,
    this.numericCode,
  });

  /// Creates a [CurrencyDTO] from a JSON
  factory CurrencyDTO.fromJson(Map<String, dynamic> json) => CurrencyDTO(
        code: json["currency"],
        name: json["name"],
        symbol: isNotEmpty(json["symbol"]) ? json["symbol"] : null,
        trfIntl: json["trf_intl"] ?? false,
        visible: json["visible"] ?? false,
        created: JsonParser.parseDate(json["ts_created"]),
        updated: JsonParser.parseDate(json["ts_updated"]),
        decimals: JsonParser.parseInt(json["decimals"]),
        rate: JsonParser.parseDouble(json["rate"]),
        buy: JsonParser.parseDouble(json["buy"]),
        sell: JsonParser.parseDouble(json["sell"]),
        numericCode:
            json["numeric_code"] is String ? json["numeric_code"] : null,
      );

  /// Returns a list of [CurrencyDTO] from a JSON
  static List<CurrencyDTO> fromJsonList(List json) =>
      json.map((currency) => CurrencyDTO.fromJson(currency)).toList();
}
