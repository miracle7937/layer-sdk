import 'package:equatable/equatable.dart';

/// Holds the data of a [Customer] limits.
class CustomerLimit extends Equatable {
  /// The daily own transfers limit.
  final Limit ownDaily;

  /// The monthly own transfer limit.
  final Limit ownMonthly;

  /// The daily card transaction limit.
  final Limit cardDaily;

  /// The monthly card transaction limit.
  final Limit cardMonthly;

  /// The daily bank transaction limit.
  final Limit bankDaily;

  /// The monthly bank transaction limit.
  final Limit bankMonthly;

  /// The daily domestic transaction limit.
  final Limit domesticDaily;

  /// The monthly domestic transaction limit.
  final Limit domesticMonthly;

  /// The daily international transaction limit.
  final Limit internationalDaily;

  /// The monthly international transaction limit.
  final Limit internationalMonthly;

  /// The daily c2c transaction limit.
  final Limit c2cDaily;

  /// The monthly c2c transaction limit.
  final Limit c2cMonthly;

  /// The daily bill transaction limit.
  final Limit billDaily;

  /// The monthly bill transaction limit.
  final Limit billMonthly;

  /// The daily topUp transaction limit.
  final Limit topUpDaily;

  /// The preferred currency of the customer.
  final String prefCurrency;

  /// Creates a new [CustomerLimit] instance.
  CustomerLimit({
    this.prefCurrency = '',
    this.bankDaily = const Limit(),
    this.bankMonthly = const Limit(),
    this.billDaily = const Limit(),
    this.billMonthly = const Limit(),
    this.c2cDaily = const Limit(),
    this.c2cMonthly = const Limit(),
    this.cardDaily = const Limit(),
    this.cardMonthly = const Limit(),
    this.domesticDaily = const Limit(),
    this.domesticMonthly = const Limit(),
    this.internationalDaily = const Limit(),
    this.internationalMonthly = const Limit(),
    this.ownDaily = const Limit(),
    this.ownMonthly = const Limit(),
    this.topUpDaily = const Limit(),
  });

  @override
  List<Object> get props {
    return [
      ownDaily,
      ownMonthly,
      cardDaily,
      cardMonthly,
      bankDaily,
      bankMonthly,
      domesticDaily,
      domesticMonthly,
      internationalDaily,
      internationalMonthly,
      c2cDaily,
      c2cMonthly,
      billDaily,
      billMonthly,
      topUpDaily,
      prefCurrency,
    ];
  }

  /// Creates a copy of a [CustomerLimit] with the provided parameters.
  CustomerLimit copyWith({
    Limit? ownDaily,
    Limit? ownMonthly,
    Limit? cardDaily,
    Limit? cardMonthly,
    Limit? bankDaily,
    Limit? bankMonthly,
    Limit? domesticDaily,
    Limit? domesticMonthly,
    Limit? internationalDaily,
    Limit? internationalMonthly,
    Limit? c2cDaily,
    Limit? c2cMonthly,
    Limit? billDaily,
    Limit? billMonthly,
    Limit? topUpDaily,
    String? prefCurrency,
  }) {
    return CustomerLimit(
      ownDaily: ownDaily ?? this.ownDaily,
      ownMonthly: ownMonthly ?? this.ownMonthly,
      cardDaily: cardDaily ?? this.cardDaily,
      cardMonthly: cardMonthly ?? this.cardMonthly,
      bankDaily: bankDaily ?? this.bankDaily,
      bankMonthly: bankMonthly ?? this.bankMonthly,
      domesticDaily: domesticDaily ?? this.domesticDaily,
      domesticMonthly: domesticMonthly ?? this.domesticMonthly,
      internationalDaily: internationalDaily ?? this.internationalDaily,
      internationalMonthly: internationalMonthly ?? this.internationalMonthly,
      c2cDaily: c2cDaily ?? this.c2cDaily,
      c2cMonthly: c2cMonthly ?? this.c2cMonthly,
      billDaily: billDaily ?? this.billDaily,
      billMonthly: billMonthly ?? this.billMonthly,
      topUpDaily: topUpDaily ?? this.topUpDaily,
      prefCurrency: prefCurrency ?? this.prefCurrency,
    );
  }
}

/// Holds the customer limit information.
class Limit extends Equatable {
  /// The actual limit value.
  final double limit;

  /// The currently used amount.
  final double usage;

  /// Returns the usage percentage in a value between `0.0` and `1.0`.
  double get usagePercentage => (usage / limit).clamp(0.0, 1.0);

  /// Returns the remaining amount of this limit.
  double get remainingAmount => limit - usage;

  /// Creates a new [Limit] instance.
  const Limit({
    this.limit = 0.0,
    this.usage = 0.0,
  });

  @override
  List<Object> get props => [
        limit,
        usage,
      ];
}
