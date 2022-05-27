import 'package:equatable/equatable.dart';

///The currency data used by the application
class Currency extends Equatable {
  ///The code that identifies the currency
  final String? code;

  ///The name of the currency
  final String? name;

  ///The symbol of the currency
  final String? symbol;

  ///Whether this currency is valid for international transfers
  final bool? trfIntl;

  ///Whether the currency is visible or not
  final bool? visible;

  ///Date the currency was created
  final DateTime? created;

  ///Last time the currency was updated
  final DateTime? updated;

  ///The amount of decimals for the currency
  final int? decimals;

  ///The rate for the currency
  final double? rate;

  ///The amount the currency is buyed for
  final double? buy;

  ///The amount the currency is selled for
  final double? sell;

  ///A numeric code that identifies the currency
  final String? numericCode;

  ///Creates a new [Currency]
  Currency({
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

  ///Checks if a the passed code matches the currency one
  bool matchesCode(String code) => code == this.code;

  @override
  List<Object?> get props => [
        code,
        name,
        symbol,
        trfIntl,
        visible,
        created,
        updated,
        decimals,
        rate,
        buy,
        sell,
        numericCode,
      ];
}
